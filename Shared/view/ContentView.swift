//
//  ContentView.swift
//  view
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: MessengerViewModel

    init(viewModel: MessengerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let conversationView = ConversationView(viewModel: viewModel)
        let contactsView = ContactsView(viewModel: viewModel)
        let isRemoteContactNil = Binding(get: {viewModel.remoteContact != nil}, set: { _ in })
        
        NavigationView {
            ZStack {
                contactsView
                NavigationLink(
                    destination: conversationView.onDisappear { viewModel.disconnectRemoteContact() },
                    isActive: isRemoteContactNil) { EmptyView() }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MessengerViewModel(
            messengerRepository: MockMessengerRepository()
        )
        ContentView(viewModel: viewModel)
    }
}
