//
//  ConversationDataSource.swift
//  model.datasource
//
//  Created by Giovani Schiar on 17/04/24.
//

import Combine

protocol ConversationDataSource {
    func retrieveContacts() -> AnyPublisher<[Contact], Never>
    func retrieveAllConversations() -> AnyPublisher<[(Contact, Message)], Never>
    func retrieveConversation(from contactID: String) -> AnyPublisher<Conversation, Never>
    func send(a message: String)
}
