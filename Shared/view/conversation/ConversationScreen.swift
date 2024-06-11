//
//  ConversationView.swift
//  view.conversation
//
//  Created by Giovani Schiar on 23/08/22.
//

import SwiftUI

struct ConversationScreen: View {
    @Binding var currentConverationUIState: CurrentConversationUIState
    let sendA: (String) -> Void
    
    @State private var message = ""
    @State private var confirmBackShowing = false
        
    @ViewBuilder var uiStateBody: some View {
        switch(currentConverationUIState) {
            case .loading:
                ProgressView().navigationTitle("Conversation")
            case .currentConversationLoaded(let conversation):
                let contact = conversation.contact
                let messages = conversation.messages
                ScrollViewReader { scrollView in
                    VStack {
                        ScrollView {
                            ForEach(Array(messages.enumerated()), id: \.element) { index, message in
                                let lastMessageDirection = messages.lastIndexDirection(index: index)
                                MessageBalloon(index: index, message: message, lastMessageDirection: lastMessageDirection)
                                Spacer().frame(
                                    height: calculateMessageBalloonMargin(index: index, direction: message.direction)
                                )
                            }.frame(maxWidth: .infinity)
                        }
                        .onAppear { scrollToBottom(scrollView) }
                        .onChange(of: messages.count) { _ in scrollToBottom(scrollView) }
                        TextFieldSendEditor(message: $message, onSizeChange: { scrollToBottom(scrollView) }) {
                            sendA(message)
                        }
                    }.frame(maxWidth: .infinity, alignment: .bottom)
                }.navigationTitle(contact.name)
        }
    }
    
    var body: some View {
        self.uiStateBody
    }
}

extension ConversationScreen {
    func scrollToBottom(_ scrollView: ScrollViewProxy) {
        switch(currentConverationUIState) {
            case .loading: return
            case .currentConversationLoaded(let conversation):
                let currentMessages = conversation.messages
                guard let last = currentMessages.last else { return }
                scrollView.scrollTo(last)
        }
    }
    
    func calculateMessageBalloonMargin(index: Int, direction: Direction) -> CGFloat {
        switch(currentConverationUIState) {
            case .loading: return 0
            case .currentConversationLoaded(let conversation):
                let currentMessages = conversation.messages
                if (index + 1 >= currentMessages.count) { return 0 }
                let nextMessageDirection = currentMessages[index + 1].direction
                if (nextMessageDirection == direction) { return Dimens.space_between_same_sender_messages }
                return Dimens.space_between_different_sender_messages
        }
    }
}
