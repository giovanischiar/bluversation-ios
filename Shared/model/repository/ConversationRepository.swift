//
//  MessagesRepository.swift
//  model.repository
//
//  Created by Giovani Schiar on 17/04/24.
//

import Foundation
import Combine

struct ConversationRepository {
    private let conversationDataSource: ConversationDataSource
    private let currentContactIDDataSource: CurrentContactIDDataSource
    
    init(
        conversationDataSource: ConversationDataSource,
        currentContactIDDataSource: CurrentContactIDDataSource
    ) {
        self.conversationDataSource = conversationDataSource
        self.currentContactIDDataSource = currentContactIDDataSource
    }
        
    var conversationPublisher: AnyPublisher<Conversation, Never> {
        currentContactIDDataSource.retrieve()
            .flatMap { contactID in self.conversationDataSource.retrieveConversation(from: contactID) }
            .eraseToAnyPublisher()
    }
    
    func send(a message: String) {
        conversationDataSource.send(a: message)
    }
}
