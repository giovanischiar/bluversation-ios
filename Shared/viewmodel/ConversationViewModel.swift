//
//  ConversationViewModel.swift
//  viewmodel
//
//  Created by Giovani Schiar on 17/04/24.
//

import Combine

class ConversationViewModel: ObservableObject {
    private let conversationRepository: ConversationRepository
    
    @Published var currentConversationUIState: CurrentConversationUIState = .loading
    
    init(conversationRepository: ConversationRepository) {
        self.conversationRepository = conversationRepository
        self.conversationRepository
            .conversationPublisher
            .map { conversation in CurrentConversationUIState.currentConversationLoaded(conversation.toViewData()) }
            .assign(to: &$currentConversationUIState)
    }
    
    func send(a message: String) {
        conversationRepository.send(a: message)
    }
}
