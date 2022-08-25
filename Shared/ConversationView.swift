//
//  ConversationView.swift
//  slowpoke
//
//  Created by Giovani Schiar on 23/08/22.
//

import SwiftUI
import Combine

struct ConversationView: View {
    @ObservedObject var viewModel: AnyViewModel
    var messageSentListener: OnMessageSentListener
    @State var messageContent = ""
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                ForEach(Array(viewModel.messages.enumerated()), id: \.element) { index, message in
                    HStack {
                        Spacer()
                            .frame(width: message.sent ? 50 : 0)
                        Text(message.content)
                            .frame(maxWidth: .infinity, alignment: message.sent ? .trailing : .leading)
                            .padding(.all, 20)
                            .background(message.sent ? .blue : .red)
                            .cornerRadius(5)
                        Spacer()
                            .frame(width: !message.sent ? 50 : 0)
                    }
                    Spacer()
                        .frame(height: index + 1 < viewModel.messages.count ? viewModel.messages[index + 1].sent == message.sent ? 5 : 10 : 5)
                }
            }
            .onAppear {
                guard let last = viewModel.messages.last else { return }
                scrollView.scrollTo(last)
            }
            .onChange(of: viewModel.messages.count) { _ in
                guard let last = viewModel.messages.last else { return }
                scrollView.scrollTo(last)
            }
            
            TextField (
                "Send Message",
                text: $messageContent
            )
            .onReceive(keyboardPublisher) { value in
                if(value) {
                    guard let last = viewModel.messages.last else { return }
                    scrollView.scrollTo(last)
                }
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .onSubmit {
                messageSentListener.send(message: messageContent)
                messageContent = ""
            }

        }
        .navigationTitle(viewModel.remotePeripheral?.name ?? "Conversation")
    }
}

