//
//  ConversationLocalDataSource.swift
//  model.datasource.local
//
//  Created by Giovani Schiar on 17/04/24.
//

import Combine

class ConversationLocalDataSource: ConversationDataSource {
    private let messengerDataSource: MessengerDataSource
    
    init(messengerDataSource: MessengerDataSource) {
        self.messengerDataSource = messengerDataSource
    }
    
    private var conversationByContactID: [String: Conversation] = [:]
    private var conversations: [Conversation] { Array(conversationByContactID.values) }
    private var connectedContacts = Set<Contact>()
    
    private lazy var messagesPublisher: AnyPublisher<(Contact, Message), Never> = messengerDataSource
        .messagesPublisher

    private lazy var contactPublisher: AnyPublisher<Contact, Never> = messengerDataSource
        .contactPublisher.removeDuplicates().map { contact in
            let contactID = contact.id.uuidString
            self.conversationByContactID[contactID] = self.conversationByContactID[contactID] ??
            Conversation(contact: contact, messages: [])
            return contact
        }.eraseToAnyPublisher()
    
    func retrieveAllConversations() -> AnyPublisher<[(Contact, Message)], Never> {
        return messagesPublisher
            .map { (contact, message) in
                let contactID = contact.id.uuidString
                var conversation = self.conversationByContactID[contactID] ??
                    Conversation(contact: contact, messages: [])
                conversation.append(a: message)
                self.conversationByContactID[contactID] = conversation
                return self.conversations.compactMap { conversation in
                    if (conversation.messages.isEmpty) { return nil }
                    return (conversation.contact, conversation.messages.last!)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func retrieveContacts() -> AnyPublisher<[Contact], Never> {
        return contactPublisher.map { _ in
            self.conversations
                .filter { conversation in conversation.messages.isEmpty }
                .map { conversation in conversation.contact }
        }.eraseToAnyPublisher()
    }
    
    func retrieveConversation(from contactID: String) -> AnyPublisher<Conversation, Never> {
        if let conversation = self.conversationByContactID[contactID] {
            let contact = conversation.contact
            if (!connectedContacts.contains(contact)) {
                connectedContacts.insert(contact)
                self.messengerDataSource.connectContact(with: contact.id.uuidString)
            }
        }
        
        return Publishers.Merge(Just(contactID as Any), messagesPublisher.map { $0 as Any })
        .compactMap { _ in self.conversationByContactID[contactID] }
        .eraseToAnyPublisher()
    }
    
    func send(a message: String) {
        messengerDataSource.send(a: message)
    }
}
