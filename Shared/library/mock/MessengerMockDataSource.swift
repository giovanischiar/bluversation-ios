//
//  MessengerMockDataSource.swift
//  model.datasource.mock
//
//  Created by Giovani Schiar on 06/10/22.
//

import struct SwiftUI.UUID
import protocol Combine.Subject
import struct Combine.AnyPublisher
import class Combine.PassthroughSubject
import class Combine.CurrentValueSubject
import enum Combine.Publishers

class MessengerMockDataSource: MessengerDataSource {
    private let mockGenerator = MockGenerator()
    private var contactsDict: [UUID: Contact]
    private var remoteContact: Contact? = nil
    private let messagesPerContactID: [UUID: [Message]]
    
    var contactPublisher: AnyPublisher<Contact, Never> {
        let contactsDict = mockGenerator.generateContacts()
        let contacts = Array(contactsDict.values.sorted(by: { $0.name ?? "no name" < $1.name ?? "no name" }))
        return Publishers.Sequence(sequence: contacts).eraseToAnyPublisher()
    }
    
    private var connectedPassthroughSubject = PassthroughSubject<Contact, Never>()
    var connectedContactPublisher: AnyPublisher<Contact, Never> {
        connectedPassthroughSubject.eraseToAnyPublisher()
    }
    
    private var disconnectedPassthroughSubject = PassthroughSubject<Contact, Never>()
    var disconnectedContactPublisher: AnyPublisher<Contact, Never> {
        disconnectedPassthroughSubject.eraseToAnyPublisher()
    }
    
    private var messagesCurrentValueSubject: Publishers.Sequence<[(Contact, Message)], Never>
    var messagesPublisher: AnyPublisher<(Contact, Message), Never> {
        messagesCurrentValueSubject.eraseToAnyPublisher()
    }
    
    init() {
        contactsDict = mockGenerator.generateContacts()
        messagesPerContactID = mockGenerator.generateMessagesPerContact()
        let messagesGenerated = contactsDict.toValuesArray().generateMessages(messagesPerContactID: messagesPerContactID)
        messagesCurrentValueSubject = messagesGenerated.publisher
    }
    
    func connectContact(with id: String) {
        let uuid = UUID(uuidString: id) ?? UUID()
        guard let contact = contactsDict[uuid] else { return }
        remoteContact = contact
        connectedPassthroughSubject.send(contact)
    }
    
    func disconnectCurrentContact() {
        guard let contact = remoteContact else { return }
        disconnectedPassthroughSubject.send(contact)
    }
    
    func send(a message: String) {
        guard let contact = remoteContact else { return }
        var messages = messagesPerContactID[contact.id] ?? []
        let messageSent = Message(sent: true, content: message)
        messages.append(messageSent)
        //messagesCurrentValueSubject.send((contact, messageSent))
    }
}

extension [UUID : Contact] {
    func toValuesArray() -> [Contact] {
        return Array(self.values)
    }
}

extension [Contact] {
    func generateMessages(messagesPerContactID: [UUID: [Message]]) -> [(Contact, Message)] {
        var messages: [(Contact, Message)] = []
        self.forEach { contact in
            let messagesFromParticularContactID = messagesPerContactID[contact.id] ?? []
            messagesFromParticularContactID.forEach { message in messages.append((contact, message)) }
        }
        
        return messages
    }
}
