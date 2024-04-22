//
//  ConversationsViewModel.swift
//  viewmodel
//
//  Created by Giovani Schiar on 17/04/24.
//

import Combine

class ConversationsViewModel: ObservableObject {
    private let conversationsRepository: ConversationsRepository
    
    @Published var contactWithLastMessageList: [(ContactViewData, MessageViewData)] = []
    @Published var contacts: [ContactViewData] = []
    
    init(contactsRepository: ConversationsRepository) {
        self.conversationsRepository = contactsRepository
        contactsRepository.contactsPublisher
            .map { $0.toViewData() }
            .assign(to: &$contacts)
        contactsRepository.contactWithLastMessageListPublisher
            .map { $0.toViewData() }
            .assign(to: &$contactWithLastMessageList)
    }
    
    func selectConversation(with contactID: String) {
        conversationsRepository.selectContact(of: contactID)
    }
    
    func selectContact(of id: String) {
        conversationsRepository.selectContact(of: id)
    }
}
