//
//  ContactsView.swift
//  view
//
//  Created by Giovani Schiar on 23/08/22.
//

import SwiftUI

struct ContactsView: View {
    @EnvironmentObject private var viewModel: MessengerViewModel
    @State private var isConfirmDisconnectAlertShowing = false
    
    var body: some View {
        List(viewModel.contacts) { contact in
            HStack {
                Text(contact.name)
                Spacer()
                generateConnectDisconnectButton(for: contact)
            }
            .alert(isPresented: .constant(viewModel.clientContact != nil)) {
                generateConnectDisconnectAlert()
            }
        }
        .listStyle(PlainListStyle())
        .alert(isPresented: $isConfirmDisconnectAlertShowing) {
            generateDisconnectAlert()
        }
        .navigationTitle("Contacts")
    }
}

extension ContactsView {
    func generateConnectDisconnectButton(for contact: ContactViewData) -> some View {
        if let remoteContact = viewModel.remoteContact {
            if (remoteContact == contact) {
                return Button("Disconnect") { isConfirmDisconnectAlertShowing = true }
            }
        }
        return Button("Connect") { viewModel.contactWasToggled(with: contact.id) }
    }
    
    func generateDisconnectAlert() -> Alert {
        Alert(
            title: Text("Disconnect to \(viewModel.remoteContact?.name ?? "")?"),
            message: Text(""),
            primaryButton: .default(Text("Ok"), action: {
                viewModel.disconnectRemoteContact()
            }),
            secondaryButton: .cancel()
        )
    }
    
    func generateConnectDisconnectAlert() -> Alert {
        var alertContent = "Connect to \(viewModel.clientContact?.name ?? "")?"
        if let clientContact = viewModel.clientContact, let remoteContact = viewModel.remoteContact {
            if clientContact != remoteContact {
                alertContent = "Disconnect to \(remoteContact.name) and connect to \(clientContact.name)?"
            }
        }
        return Alert(
            title: Text(alertContent),
            message: Text(""),
            primaryButton: .default(Text("Ok"), action: { viewModel.connectClientContact()}),
            secondaryButton: .cancel {
                guard let id = viewModel.clientContact?.id else { return }
                viewModel.contactWasToggled(with: id)
            }
        )
    }
}
