//
//  ContactsScreen.swift
//  view.messages.component
//
//  Created by Giovani Schiar on 23/08/22.
//

import SwiftUI

struct ContactsDialog: View {
    let contactsUIState: ContactsUIState
    let onContactSelectedWith: (String) -> Void
    @State private var isConfirmDisconnectAlertShowing = false
    
    @ViewBuilder var uiStateBody: some View {
        switch(contactsUIState) {
            case .loading: ProgressView()
            case .contactsLoaded(let contacts):
                List(contacts, id: \.id) { contact in
                    HStack {
                        Button(contact.name) {
                            onContactSelectedWith(contact.id)
                        }
                    }
                }
                .listStyle(PlainListStyle())
        }
    }
    
    var body: some View {
        self.uiStateBody
            .navigationTitle("Contacts")
    }
}
