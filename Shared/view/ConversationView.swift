//
//  ConversationView.swift
//  view
//
//  Created by Giovani Schiar on 23/08/22.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject private var viewModel: MessengerViewModel
    @State private var message = ""
    @State private var confirmBackShowing = false
        
    var body: some View {
        ScrollViewReader { scrollView in
            VStack {
                ScrollView {
                    ForEach(Array(viewModel.currentConversation.enumerated()), id: \.element) { index, message in
                        let lastMessageDirection = viewModel.currentConversation.lastIndexDirection(index: index)
                        MessageBalloon(index: index, message: message, lastMessageDirection: lastMessageDirection)
                        Spacer().frame(
                            height: calculateMessageBalloonMargin(index: index, direction: message.direction)
                        )
                    }.frame(maxWidth: .infinity)
                }
                .onAppear { scrollToBottom(scrollView) }
                .onChange(of: viewModel.currentConversation.count) { _ in scrollToBottom(scrollView) }
                TextFieldSendEditor(message: $message, onSizeChange: { scrollToBottom(scrollView) }) {
                    viewModel.send(a: message)
                }
            }.frame(maxWidth: .infinity, alignment: .bottom)
        }
        .navigationTitle(viewModel.remoteContact?.name ?? "Conversation")
#if os(iOS)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {confirmBackShowing = true }){
            HStack { Image(systemName: "arrow.left"); Text("Contacts") }
         })
        .alert(isPresented: $confirmBackShowing) {
            Alert(
                title: Text("Disconnect to \(viewModel.remoteContact?.name ?? "")?"),
                message: Text(""),
                primaryButton: .default(Text("Ok")) { viewModel.disconnectRemoteContact() },
                secondaryButton: .cancel()
            )
        }
#endif
    }
}

extension ConversationView {
    func scrollToBottom(_ scrollView: ScrollViewProxy) {
        guard let last = viewModel.currentConversation.last else { return }
        scrollView.scrollTo(last)
    }
    
    func calculateMessageBalloonMargin(index: Int, direction: Direction) -> CGFloat {
        let currentMessages = viewModel.currentConversation
        if (index + 1 >= currentMessages.count) { return 0 }
        let nextMessageDirection = currentMessages[index + 1].direction
        if (nextMessageDirection == direction) { return Dimens.space_between_same_sender_messages }
        return Dimens.space_between_different_sender_messages
    }
}
