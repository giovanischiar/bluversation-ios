//
//  ConversationsScreen.swift
//  view.messages
//
//  Created by Giovani Schiar on 01/09/22.
//

import SwiftUI

struct ConversationsScreen: View {
    @Binding var contactWithLastMessageListUIState: ContactWithLastMessageListUIState
    @Binding var contactsUIState: ContactsUIState
    @Binding var currentContactIDUIState: CurrentContactIDUIState
    let selectConversationWith: (String) -> Void
    let selectContactOf: (_ of: String) -> Void
    let onNavigateToConversation: () -> Void
    
    private var currentContactID: String {
        switch (self.currentContactIDUIState) {
            case .loading: return ""
            case .currentContactIDLoaded(let currentContactID): return currentContactID
        }
    }
    
    @State private var showingPopup = false
    @State private var showContactsList = false
    
    @ViewBuilder var uiStateBody: some View {
        switch(contactWithLastMessageListUIState) {
            case .loading:
                ProgressView()
            case .contactWithLastMessageListLoaded(let contactWithLastMessageList):
                List(contactWithLastMessageList, id: \.1.id) { (contact, message) in
                    MessageView(
                        contact: contact,
                        lastMessage: message,
                        isSelected: currentContactID == contact.id
                    ) {
                        selectContactOf(contact.id)
                        selectConversationWith(contact.id);
                        onNavigateToConversation()
                    }
                }
                .listStyle(.plain)
        }
    }
   
    var body: some View {
        self.uiStateBody
            .navigationTitle("Messages")
            .toolbar {
                Button(action: { showContactsList = true } ) {
                    Image(systemName: "square.and.pencil").renderingMode(.original)
                }
            }.popover(isPresented: $showContactsList) {
                ContactsDialog(
                    contactsUIState: contactsUIState,
                    onContactSelectedWith: { id in
                        selectConversationWith(id)
                        showContactsList = false
                        onNavigateToConversation()
                    }
                )
            }
    }
}
