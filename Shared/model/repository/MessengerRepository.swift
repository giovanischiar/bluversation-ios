//
//  MessengerRepository.swift
//  model.repository
//
//  Created by Giovani Schiar on 06/10/22.
//

import struct Foundation.UUID
import class Combine.AnyCancellable
import struct Combine.AnyPublisher

class MessengerRepository {
    var contactsPublisher: AnyPublisher<Contact, Never>
    var messagesPublisher: AnyPublisher<[(Contact, Message)], Never>
    
    private let messengerDataSource: MessengerDataSource
    private var messagesPerContact: [UUID:[Message]] = [:]
    private var contacts: [UUID: Contact] = [:]
    private var remoteContact: Contact? = nil
    private var cancellables: Set<AnyCancellable> = []

    init(messengerDataSource: MessengerDataSource) {
        self.messengerDataSource = messengerDataSource
        messagesPublisher = messengerDataSource.messagesPublisher
        contactsPublisher = messengerDataSource.contactPublisher
        registerForMessagesAndContacts()
    }
    
    func registerForMessagesAndContacts() {
        messengerDataSource.messagesPublisher.sink { (messages: [(Contact, Message)]) in
            messages.forEach { (contact, message) in
                let id = contact.id
                var messages = self.messagesPerContact[id] ?? []
                messages.append(message)
                self.messagesPerContact[id] = messages
            }
        }
        .store(in: &cancellables)
        messengerDataSource.contactPublisher.sink {
            self.contacts[$0.id] = $0
        }
        .store(in: &cancellables)
    }
    
    func lastMessageOfEachContact() -> [(Contact, Message)] {
        return messagesPerContact.filter{$1.last != nil && contacts[$0] != nil}.map {
            (contacts[$0]!, $1.last!)
        }
    }
    
    func connectContact(with id: String, callback: @escaping (Contact, [Message]) -> Void) {
         messengerDataSource.connectedContactPublisher
             .sink { contact in
                 self.remoteContact = contact
                 let messagesFromContact = self.messagesPerContact[contact.id] ?? []
                 callback(contact, messagesFromContact)
             }
             .store(in: &cancellables)
         messengerDataSource.connectContact(with: id)
    }
    
    func disconnectRemoteContact(callback: @escaping (Contact) -> Void) {
         messengerDataSource.disconnectedContactPublisher.sink { contact in
             let contactDisconnected = contact
             callback(contactDisconnected)
         }
         .store(in: &cancellables)
         messengerDataSource.disconnectCurrentContact()
    }
    
    func send(a message: String) {
        messengerDataSource.send(a: message)
    }
}
