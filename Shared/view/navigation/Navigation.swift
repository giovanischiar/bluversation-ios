//
//  Navigation.swift
//  Bluversation
//
//  Created by Giovani Schiar on 11/06/24.
//

import SwiftUI

struct Navigation: View {
    @EnvironmentObject var conversationsViewModel: ConversationsViewModel
    @EnvironmentObject var conversationViewModel: ConversationViewModel
    
    @State var isNavigationLinkToConversationActive = false
    
    var body: some View {
        let conversationsScreen = ConversationsScreen(
            contactWithLastMessageListUIState: $conversationsViewModel.contactWithLastMessageListUIState,
            contactsUIState: $conversationsViewModel.contactsUIState,
            currentContactIDUIState: $conversationsViewModel.currentContactIDUIState,
            selectConversationWith: conversationsViewModel.selectConversation(with:),
            selectContactOf: conversationsViewModel.selectContact(of:),
            onNavigateToConversation: { isNavigationLinkToConversationActive = true }
        )
        let conversationScreen = ConversationScreen(
            currentConverationUIState: $conversationViewModel.currentConversationUIState,
            sendA: conversationViewModel.send(a:)
        )
#if os(iOS)
        NavigationView {
            VStack {
                conversationsScreen
                NavigationLink(
                    destination: conversationScreen,
                    isActive: $isNavigationLinkToConversationActive
                ) { EmptyView() }
            }
        }
#else
        NavigationView {
            conversationsScreen
            conversationScreen
        }
#endif
    }
}

