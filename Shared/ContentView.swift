//
//  ContentView.swift
//  Shared
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: MessagesViewModel
    private var peripheralConnectedListener: OnPeripheralConnectedListener
    private var peripheralDisconnectedListener: OnRemotePeripheralDisconnectedListener
    private var messageSentListener: OnMessageSentListener

    init(
        viewModel: MessagesViewModel,
        peripheralConnectedListener: OnPeripheralConnectedListener,
        peripheralDisconnectedListener: OnRemotePeripheralDisconnectedListener,
        messageSentListener: OnMessageSentListener
    ) {
        self.viewModel = viewModel
        self.peripheralConnectedListener = peripheralConnectedListener
        self.peripheralDisconnectedListener = peripheralDisconnectedListener
        self.messageSentListener = messageSentListener
    }
    
    var body: some View {
        let conversationView = ConversationView(viewModel: viewModel, messageSentListener: messageSentListener)
        let peripheralsView = PeripheralsView(
            viewModel: viewModel,
            peripheralConnectedListener: peripheralConnectedListener
        )
        let isRemotePeripheralNil = Binding(get: {viewModel.remotePeripheral != nil}, set: { _ in })
        
        NavigationView {
            ZStack {
                peripheralsView
                NavigationLink(
                    destination: conversationView.onDisappear { self.peripheralDisconnectedListener.onRemotePeripheralDisconnect() },
                    isActive: isRemotePeripheralNil) { EmptyView() }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(viewModel: Me)
//    }
//}
