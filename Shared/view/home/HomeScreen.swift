//
//  HomeScreen.swift
//  view.home
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI

struct HomeScreen: View {
    @State var isNavigationLinkToConversationActive = false
    
    var body: some View {
        let conversationsScreen = ConversationsScreen(
            onNavigateToConversation: { isNavigationLinkToConversationActive = true }
        )
        let conversationScreen = ConversationScreen()
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

struct HomeScreen_Previews: PreviewProvider {
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
        HomeScreen()
            .environmentObject(contactsViewModel)
            .environmentObject(conversationViewModel)
    }
}
