//
//  ConversationsScreen.swift
//  view.messages
//
//  Created by Giovani Schiar on 01/09/22.
//

import SwiftUI

struct ConversationsScreen: View {
    @EnvironmentObject private var contactsViewModel: ConversationsViewModel
    private let onNavigateToConversation: () -> Void
    
    init(onNavigateToConversation: @escaping () -> Void) {
        self.onNavigateToConversation = onNavigateToConversation
    }
    
    @State private var showingPopup = false
    @State private var showContactsList = false
   
    var body: some View {
        List(contactsViewModel.contactWithLastMessageList, id: \.1.id) { contact in
            let (contact, message) = contact
            MessageView(
                contact: contact,
                lastMessage: message
            ) { contactsViewModel.selectConversation(with: contact.id); onNavigateToConversation() }
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
                contacts: contactsViewModel.contacts,
                onContactSelectedWith: { id in
                    contactsViewModel.selectConversation(with: id)
                    showContactsList = false
                    onNavigateToConversation()
                }
            )
        }
    }
}
