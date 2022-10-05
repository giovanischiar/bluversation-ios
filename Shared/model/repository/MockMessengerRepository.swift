//
//  MockMessengerRepository.swift
//  repository
//
//  Created by Giovani Schiar on 24/08/22.
//

import struct Foundation.UUID

class MockMessengerRepository: MessengerRepository {
    private let mockGenerator = MockGenerator()
    
    private let contacts: [UUID: Contact]
    private var messagesPerContact: [UUID: [Message]] = [:]
    private var remoteContact: Contact? = nil
    
    private var messageSentCallback: ((Contact, Message) -> Void)?
    
    init() {
        contacts = mockGenerator.generateContacts()
        messagesPerContact = mockGenerator.generateMessagesPerContact()
    }
    
    func lastMessageOfEachContact() -> [(Contact, Message)] {
        return messagesPerContact.filter{$1.last != nil && contacts[$0] != nil}.map {
            (contacts[$0]!, $1.last!)
        }
    }
    
    func registerForContacts(callback: @escaping (_ contact: Contact) -> Void) {
        for contact in contacts.values.sorted(by: { $0.name ?? "no name" < $1.name ?? "no name" }) {
            callback(contact)
        }
    }
    
    func registerForMessages(callback: @escaping (_ contact: Contact, _ message: Message) -> Void) {
        messageSentCallback = callback
    }
    
    func connectContact(with id: String, callback: @escaping (Contact, [Message]) -> Void) {
        let uuid = UUID(uuidString: id) ?? UUID()
        guard let contact = contacts[uuid] else { return }
        remoteContact = contact
        let messagesFromContact = self.messagesPerContact[contact.id] ?? []
        callback(contact, messagesFromContact)
    }
    
    func disconnectRemoteContact(callback: @escaping (_ contact: Contact) -> Void) {
        guard let contact = remoteContact else { return }
        callback(contact)
    }
    
    func send(a message: String) {
        guard let contact = remoteContact else { return }
        var messages = messagesPerContact[contact.id] ?? []
        let messageSent = Message(sent: true, content: message)
        messages.append(Message(sent: true, content: message))
        messagesPerContact[contact.id] = messages
        if let messageSentCallback = self.messageSentCallback {
            messageSentCallback(contact, messageSent)
        }
    }
}
