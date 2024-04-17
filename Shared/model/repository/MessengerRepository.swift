//
//  MessengerRepository.swift
//  repository
//
//  Created by Giovani Schiar on 06/10/22.
//

import struct Foundation.UUID
import class Combine.AnyCancellable
import struct Combine.AnyPublisher

class MessengerRepository {
    private let messengerTech: MessengerTech
    private var messagesPerContact: [UUID:[Message]] = [:]
    private var contacts: [UUID: Contact] = [:]
    private var remoteContact: Contact? = nil
    private var cancellables: Set<AnyCancellable> = []
    var contactsPublisher: AnyPublisher<Contact, Never>
    var messagesPublisher: AnyPublisher<[(Contact, Message)], Never>
    
    init(messengerTech: MessengerTech) {
        self.messengerTech = messengerTech
        messagesPublisher = messengerTech.messagesPublisher
        contactsPublisher = messengerTech.contactPublisher
        registerForMessagesAndContacts()
    }
    
    func registerForMessagesAndContacts() {
        messengerTech.messagesPublisher.sink { (messages: [(Contact, Message)]) in
            messages.forEach { (contact, message) in
                let id = contact.id
                var messages = self.messagesPerContact[id] ?? []
                messages.append(message)
                self.messagesPerContact[id] = messages
            }
        }
        .store(in: &cancellables)
        messengerTech.contactPublisher.sink {
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
         messengerTech.connectedContactPublisher
             .sink { contact in
                 self.remoteContact = contact
                 let messagesFromContact = self.messagesPerContact[contact.id] ?? []
                 callback(contact, messagesFromContact)
             }
             .store(in: &cancellables)
         messengerTech.connectContact(with: id)
    }
    
    func disconnectRemoteContact(callback: @escaping (Contact) -> Void) {
         messengerTech.disconnectedContactPublisher.sink { contact in
             let contactDisconnected = contact
             callback(contactDisconnected)
         }
         .store(in: &cancellables)
         messengerTech.disconnectCurrentContact()
    }
    
    func send(a message: String) {
        messengerTech.send(a: message)
    }
}
