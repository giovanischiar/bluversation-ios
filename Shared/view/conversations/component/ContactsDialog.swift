//
//  ContactsScreen.swift
//  view.messages.component
//
//  Created by Giovani Schiar on 23/08/22.
//

import SwiftUI

struct ContactsDialog: View {
    let contacts: [ContactViewData]
    let onContactSelectedWith: (String) -> Void
    @State private var isConfirmDisconnectAlertShowing = false
    
    var body: some View {
        List(contacts, id: \.id) { contact in
            HStack {
                Button(contact.name) {
                    onContactSelectedWith(contact.id)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Contacts")
    }
}
