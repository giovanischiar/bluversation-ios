//
//  BluetoothMessengerRepository.swift
//  repository
//
//  Created by Giovani Schiar on 24/08/22.
//

import class Combine.AnyCancellable
import struct Foundation.UUID

class BluetoothMessengerRepository: MessengerRepository {
    private var bluetoothManager = BluetoothManager()
    private var cancellables: Set<AnyCancellable> = []
    private var messagesPerContact: [UUID:[Message]] = [:]
    private var remoteContact: Contact?
    
    func registerForContacts(callback: @escaping (_ contact: Contact) -> Void) {
        bluetoothManager.peripheralPublisher
            .sink { peripheral in
                let contact = Contact(id: peripheral.identifier, name: peripheral.name, description: peripheral.description)
                callback(contact)
            }
            .store(in: &cancellables)
    }
    
    func registerForMessages(callback: @escaping (_ message: Message) -> Void) {
        bluetoothManager.messageSentPublisher
            .sink {
                guard let id = self.remoteContact?.id else { return }
                var messages = self.messagesPerContact[id] ?? []
                let message = Message(sent: true, content: $0)
                messages.append(message)
                self.messagesPerContact[id] = messages
                callback(message)
            }
            .store(in: &cancellables)
        
        bluetoothManager.messageReceivedPublisher
            .sink {
                guard let id = self.remoteContact?.id else { return }
                var messages = self.messagesPerContact[id] ?? []
                let message = Message(sent: false, content: $0)
                messages.append(message)
                self.messagesPerContact[id] = messages
                callback(message)
            }
            .store(in: &cancellables)
    }
    
    func connectContact(with id: String, callback: @escaping (_ contact: Contact, _ messages: [Message]) -> Void) {
        bluetoothManager.connectedPeripheralPublisher
            .sink { peripheral in
                let remoteContact = Contact(id: peripheral.identifier, name: peripheral.name, description: peripheral.description)
                self.remoteContact = remoteContact
                let messagesFromContact = self.messagesPerContact[remoteContact.id] ?? []
                callback(remoteContact, messagesFromContact)
            }
            .store(in: &cancellables)
        bluetoothManager.connectPeripheral(with: id)
    }
    
    func disconnectRemoteContact(callback: @escaping (_ contact: Contact) -> Void) {
        bluetoothManager.disconnectedPeripheralPublisher.sink { peripheral in
            let contactDisconnected = Contact(id: peripheral.identifier, name: peripheral.name, description: peripheral.description)
            callback(contactDisconnected)
        }
        .store(in: &cancellables)
        bluetoothManager.disconnectCurrentPeripheral()
    }
    
    func send(a message: String) {
        bluetoothManager.send(a: message)
    }
}
