//
//  BluetoothMessengerRepository.swift
//  repository
//
//  Created by Giovani Schiar on 24/08/22.
//

import class Combine.AnyCancellable
import struct Foundation.UUID
import CoreBluetooth

class BluetoothMessengerRepository: MessengerRepository {
    private var bluetoothManager = BluetoothManager()
    private var cancellables: Set<AnyCancellable> = []
    private var messagesPerContact: [UUID:[Message]] = [:]
    private var contacts: [UUID:Contact] = [:]
    private var remoteContact: Contact?
    
    func lastMessageOfEachContact() -> [(Contact, Message)] {
        return messagesPerContact.filter{$1.last != nil && contacts[$0] != nil}.map {
            (contacts[$0]!, $1.last!)
        }
    }
    
    func registerForContacts(callback: @escaping (_ contact: Contact) -> Void) {
        bluetoothManager.peripheralPublisher
            .sink {
                self.contacts[$0.identifier] = $0.toContact()
                callback($0.toContact())
            }
            .store(in: &cancellables)
    }
    
    func registerForMessages(callback: @escaping (_ contact: Contact, _ message: Message) -> Void) {
        bluetoothManager.messageSentPublisher
            .sink {
                guard let contact = self.remoteContact else { return }
                let id = contact.id
                var messages = self.messagesPerContact[id] ?? []
                let message = Message(sent: true, content: $0)
                messages.append(message)
                self.messagesPerContact[id] = messages
                callback(contact, message)
            }
            .store(in: &cancellables)
        
        bluetoothManager.messageReceivedPublisher
            .sink { peripheral, message in
                var messages = self.messagesPerContact[peripheral.identifier] ?? []
                let message = Message(sent: false, content: message)
                messages.append(message)
                self.messagesPerContact[peripheral.identifier] = messages
                callback(peripheral.toContact(), message)
            }
            .store(in: &cancellables)
    }
    
    func connectContact(with id: String, callback: @escaping (_ contact: Contact, _ messages: [Message]) -> Void) {
        bluetoothManager.connectedPeripheralPublisher
            .sink { peripheral in
                let remoteContact = peripheral.toContact()
                self.remoteContact = remoteContact
                let messagesFromContact = self.messagesPerContact[remoteContact.id] ?? []
                callback(remoteContact, messagesFromContact)
            }
            .store(in: &cancellables)
        bluetoothManager.connectPeripheral(with: id)
    }
    
    func disconnectRemoteContact(callback: @escaping (_ contact: Contact) -> Void) {
        bluetoothManager.disconnectedPeripheralPublisher.sink { peripheral in
            let contactDisconnected = peripheral.toContact()
            callback(contactDisconnected)
        }
        .store(in: &cancellables)
        bluetoothManager.disconnectCurrentPeripheral()
    }
    
    func send(a message: String) {
        bluetoothManager.send(a: message)
    }
}

extension CBPeripheral {
    func toContact() -> Contact {
        return Contact(id: self.identifier, name: self.name, description: self.description)
    }
}
