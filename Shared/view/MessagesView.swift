//
//  MessagesView.swift
//  view
//
//  Created by Giovani Schiar on 01/09/22.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject private var viewModel: MessengerViewModel
    @State private var isConfirmDisconnectAlertShowing = false
   
    var body: some View {
        List(viewModel.messages, id: \(ContactViewData, MessageViewData).0.id) { contact, message in
            ListItem(
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
    }

}

struct ListItem: View {
    private var contact: ContactViewData
    private var lastMessage: MessageViewData?
    private var isRemoteContact: Bool
    @Binding private var isConfirmDisconnectAlertShowing: Bool
    private var onTap: () -> Void
    
    @State private var isConnectDisconnectOverlayShowing = false
    
    init(
        contact: ContactViewData,
        lastMessage: MessageViewData?,
        isRemoteContact: Bool,
        isConfirmDisconnectAlertShowing: Binding<Bool>,
        onTap: @escaping () -> Void
    ) {
        self.contact = contact
        self.lastMessage = lastMessage
        self.isRemoteContact = isRemoteContact
        self._isConfirmDisconnectAlertShowing = isConfirmDisconnectAlertShowing
        self.onTap = onTap
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 50, height: 50)
                VStack {
                    HStack {
                        Text(contact.name)
                        Spacer()
                    }
                    HStack {
                        Text(lastMessage?.content ?? "I decided to go to one last mystery island before bed and ended up on shark island for the first time!")
                            .lineLimit(1)
                        Spacer()
                    }
                }
            }
        }
        .onTapGesture(perform: generateConnectDisconnectButton(
            for: contact, isRemoteContact: isRemoteContact, onTap: onTap
        ))
        .overlay {
            ZStack { Text(isRemoteContact ? "Disconnect" : "Connect") }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .opacity(isConnectDisconnectOverlayShowing ? 0.95 : 0)
            .onTapGesture(perform: generateConnectDisconnectButton(
                for: contact, isRemoteContact: isRemoteContact, onTap: onTap
            ))
        }
        .onHover { over in isConnectDisconnectOverlayShowing = over }
    }
}

extension ListItem {
    func generateConnectDisconnectButton(
        for contact: ContactViewData,
        isRemoteContact: Bool,
        onTap: @escaping () -> Void
    ) -> (() -> Void) {
        if isRemoteContact {
            return { isConfirmDisconnectAlertShowing = true }
        }
        return onTap
    }
}

extension MessagesView {
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
