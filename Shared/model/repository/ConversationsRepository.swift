//
//  ContactsRepository.swift
//  model.repository
//
//  Created by Giovani Schiar on 17/04/24.
//

import Foundation
import Combine

struct ConversationsRepository {
    private let conversationDataSource: ConversationDataSource
    private let currentContactIDDataSource: CurrentContactIDDataSource
    
    init(
        conversationDataSource: ConversationDataSource,
        currentContactIDDataSource: CurrentContactIDDataSource
    ) {
        self.conversationDataSource = conversationDataSource
        self.currentContactIDDataSource = currentContactIDDataSource
    }
    
    var contactWithLastMessageListPublisher: AnyPublisher<[(Contact, Message)], Never> {
        conversationDataSource.retrieveAllConversations()
    }
    
    var contactsPublisher: AnyPublisher<[Contact], Never> {
        conversationDataSource.retrieveContacts()
    }
    
    func selectContact(of id: String) {
        currentContactIDDataSource.update(id: id)
    }
}
