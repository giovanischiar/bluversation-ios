//
//  ContentView.swift
//  view
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: MessengerViewModel
    
    var body: some View {
        let contactsView = ContactsView()
        let conversationView = ConversationView()
#if os(iOS)
        NavigationView {
            VStack {
                contactsView
                NavigationLink(
                    destination: conversationView,
                    isActive: .constant(viewModel.remoteContact != nil)
                ) { EmptyView() }
            }
        }
#else
        NavigationView {
            contactsView
            conversationView
        }
#endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MessengerViewModel(messengerRepository: MockMessengerRepository())
        ContentView().environmentObject(viewModel)
    }
}