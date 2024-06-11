//
//  BluversationApp.swift
//  Shared
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI

@main
struct BluversationApp: App {
    @ObservedObject private var conversationsViewModel: ConversationsViewModel
    @ObservedObject private var conversationViewModel: ConversationViewModel
    
    init() {
        let messengerDataSource = MessengerBluetoothDataSource()
        let currentContactIDDataSource = CurrentContactIDLocalDataSource()
        let conversationDataSource = ConversationLocalDataSource(messengerDataSource: messengerDataSource)
        
        conversationsViewModel = ConversationsViewModel(
            contactsRepository: ConversationsRepository(
                conversationDataSource: conversationDataSource,
                currentContactIDDataSource: currentContactIDDataSource
            )
        )
        
        conversationViewModel = ConversationViewModel(
            conversationRepository: ConversationRepository(
                conversationDataSource: conversationDataSource,
                currentContactIDDataSource: currentContactIDDataSource
            )
        )
    }
    
    var body: some Scene {
        WindowGroup {
            Navigation()
                .environmentObject(conversationsViewModel)
                .environmentObject(conversationViewModel)
        }
    }
}

struct Bluversation_Previews: PreviewProvider {
    static var previews: some View {
        let messengerDataSource = MessengerMockDataSource()
        let currentContactIDDataSource = CurrentContactIDLocalDataSource()
        let conversationDataSource = ConversationLocalDataSource(messengerDataSource: messengerDataSource)
        
        let contactsViewModel = ConversationsViewModel(
            contactsRepository: ConversationsRepository(
                conversationDataSource: conversationDataSource,
                currentContactIDDataSource: currentContactIDDataSource
            )
        )
        
        let conversationViewModel = ConversationViewModel(
            conversationRepository: ConversationRepository(
                conversationDataSource: conversationDataSource,
                currentContactIDDataSource: currentContactIDDataSource
            )
        )
        Navigation()
            .environmentObject(contactsViewModel)
            .environmentObject(conversationViewModel)
    }
}
