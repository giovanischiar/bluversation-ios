//
//  MessagesView.swift
//  view.messages
//
//  Created by Giovani Schiar on 01/09/22.
//

import SwiftUI

struct MessagesScreen: View {
    @EnvironmentObject private var viewModel: MessengerViewModel
    @State private var isConfirmDisconnectAlertShowing = false
    @State private var showingPopup = false
   
    var body: some View {
        List(viewModel.messages, id: \(ContactViewData, MessageViewData).0.id) { contact, message in
            MessageView(
                contact: contact,
                lastMessage: message,
                isRemoteContact: contact == viewModel.remoteContact,
                isConfirmDisconnectAlertShowing: $isConfirmDisconnectAlertShowing
            ) { viewModel.contactWasToggled(with: contact.id) }
            .alert(isPresented: .constant(viewModel.clientContact != nil)) {
                generateConnectDisconnectAlert()
            }
        }
        .listStyle(.plain)
        .alert(isPresented: $isConfirmDisconnectAlertShowing) {
            generateDisconnectAlert()
        }
        .navigationTitle("Messages")
        .toolbar {
            Button(action: { viewModel.showContactsList = true } ) {
                Image(systemName: "square.and.pencil").renderingMode(.original)
            }
        }
        .popover(isPresented: $viewModel.showContactsList) { ContactsDialog() }
    }
}

extension MessagesScreen {
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
