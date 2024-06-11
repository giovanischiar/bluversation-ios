//
//  ConversationsViewModel.swift
//  viewmodel
//
//  Created by Giovani Schiar on 17/04/24.
//

import Combine

class ConversationsViewModel: ObservableObject {
    private let conversationsRepository: ConversationsRepository
    
    @Published var contactWithLastMessageListUIState: ContactWithLastMessageListUIState = .loading
    @Published var contactsUIState: ContactsUIState = .loading
    @Published var currentContactIDUIState: CurrentContactIDUIState = .loading
    
    init(contactsRepository: ConversationsRepository) {
        self.conversationsRepository = contactsRepository
        contactsRepository.contactWithLastMessageListPublisher
            .map { ContactWithLastMessageListUIState.contactWithLastMessageListLoaded($0.toViewData()) }
            .assign(to: &$contactWithLastMessageListUIState)
        
        contactsRepository.contactsPublisher
            .map { ContactsUIState.contactsLoaded($0.toViewData()) }
            .assign(to: &$contactsUIState)
    }
    
    func selectConversation(with contactID: String) {
        conversationsRepository.selectContact(of: contactID)
    }
    
    func selectContact(of id: String) {
        currentContactIDUIState = CurrentContactIDUIState.currentContactIDLoaded(id)
        conversationsRepository.selectContact(of: id)
    }
}
