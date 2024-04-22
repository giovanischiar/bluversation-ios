//
//  ConversationViewModel.swift
//  viewmodel
//
//  Created by Giovani Schiar on 17/04/24.
//

import Combine

class ConversationViewModel: ObservableObject {
    private let conversationRepository: ConversationRepository
    
    @Published var conversation: ConversationViewData? = nil
    
    init(conversationRepository: ConversationRepository) {
        self.conversationRepository = conversationRepository
        self.conversationRepository
            .conversationPublisher
            .map { conversation in conversation.toViewData() }
            .assign(to: &$conversation)
    }
    
    func send(a message: String) {
        conversationRepository.send(a: message)
    }
}
