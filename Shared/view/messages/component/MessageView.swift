//
//  MessageView.swift
//  view.messages.component
//
//  Created by Giovani Schiar on 17/04/24.
//

import SwiftUI

struct MessageView: View {
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

extension MessageView {
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
