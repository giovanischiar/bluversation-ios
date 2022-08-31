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
                    ForEach(Array(viewModel.currentMessages.enumerated()), id: \.element) { index, message in
                        let lastMessageDirection = viewModel.currentMessages.lastIndexDirection(index: index)
                        MessageBalloon(index: index, message: message, lastMessageDirection: lastMessageDirection)
                        Spacer().frame(
                            height: calculateMessageBalloonMargin(index: index, direction: message.direction)
                        )
                    }.frame(maxWidth: .infinity)
                }
                .onAppear { scrollToBottom(scrollView) }
                .onChange(of: viewModel.currentMessages.count) { _ in scrollToBottom(scrollView) }
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
        guard let last = viewModel.currentMessages.last else { return }
        scrollView.scrollTo(last)
    }
    
    func calculateMessageBalloonMargin(index: Int, direction: Direction) -> CGFloat {
        let currentMessages = viewModel.currentMessages
        if (index + 1 >= currentMessages.count) { return 0 }
        let nextMessageDirection = currentMessages[index + 1].direction
        if (nextMessageDirection == direction) { return Dimens.space_between_same_sender_messages }
        return Dimens.space_between_different_sender_messages
    }
}

struct TextFieldSendEditor: View {
    @Binding var message: String
    var onSizeChange: () -> Void
    var onSendPressed: () -> Void
    
    @State var textEditorHeight: CGFloat = 20
    var maxHeight: CGFloat = 250
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Text(message)
                    .font(.system(.body))
                    .foregroundColor(.clear)
                    .padding(6)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewHeightKey.self,
                                               value: $0.frame(in: .local).size.height)
                    })
                TextEditor(text: $message)
                    .font(.system(.body))
                    .padding(6)
                    .frame(height: min(textEditorHeight, maxHeight))
            }
#if os(macOS)
            .border(SeparatorShapeStyle())
#endif
            .onReceive(keyboardPublisher) { value in
                if(value) {
                    onSizeChange()
                }
            }
            Button("Send") {
                onSendPressed()
                message = ""
            }
        }
        .padding()
        .onPreferenceChange(ViewHeightKey.self) {
            textEditorHeight = $0
            onSizeChange()
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
