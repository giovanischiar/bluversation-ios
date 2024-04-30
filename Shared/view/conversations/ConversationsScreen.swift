//
//  ConversationsScreen.swift
//  view.messages
//
//  Created by Giovani Schiar on 01/09/22.
//

import SwiftUI

struct ConversationsScreen: View {
    @EnvironmentObject private var conversationsViewModel: ConversationsViewModel
    private let onNavigateToConversation: () -> Void
    
    init(onNavigateToConversation: @escaping () -> Void) {
        self.onNavigateToConversation = onNavigateToConversation
    }
    
    @State private var showingPopup = false
    @State private var showContactsList = false
   
    var body: some View {
        List(conversationsViewModel.contactWithLastMessageList, id: \.1.id) { (contact, message) in
            MessageView(
                contact: contact,
                lastMessage: message,
                isSelected: conversationsViewModel.currentContactID == contact.id
            ) {
                conversationsViewModel.currentContactID = contact.id
                conversationsViewModel.selectConversation(with: contact.id);
                onNavigateToConversation()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Messages")
        .toolbar {
            Button(action: { showContactsList = true } ) {
                Image(systemName: "square.and.pencil").renderingMode(.original)
            }
        }
        .popover(isPresented: $showContactsList) {
            ContactsDialog(
                contacts: conversationsViewModel.contacts,
                onContactSelectedWith: { id in
                    conversationsViewModel.selectConversation(with: id)
                    showContactsList = false
                    onNavigateToConversation()
                }
            )
        }
    }
}
