//
//  SlowpokeApp.swift
//  Shared
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI

@main
struct SlowpokeApp: App {
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
            HomeScreen()
                .environmentObject(conversationsViewModel)
                .environmentObject(conversationViewModel)
        }
    }
}
