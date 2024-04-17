//
//  ContentView.swift
//  view.home
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var viewModel: MessengerViewModel
    
    var body: some View {
        let messagesScreen = MessagesScreen()
        let conversationScreen = ConversationScreen()
#if os(iOS)
        NavigationView {
            VStack {
                messagesScreen
                NavigationLink(
                    destination: conversationScreen,
                    isActive: .constant(viewModel.remoteContact != nil)
                ) { EmptyView() }
            }
        }
#else
        NavigationView {
            messagesScreen
            conversationScreen
        }
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MessengerViewModel(
            messengerRepository: MessengerRepository(
                messengerDataSource: MessengerMockDataSource()
            )
        )
        HomeScreen().environmentObject(viewModel)
    }
}
