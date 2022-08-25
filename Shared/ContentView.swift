//
//  ContentView.swift
//  Shared
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI
import Combine
import CoreBluetooth

struct ContentView: View {
    @ObservedObject private var viewModel: AnyViewModel
    private var bluetoothManager: BluetoothManager = BluetoothManager()
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: AnyViewModel) {
        self.viewModel = viewModel
        setPublishers(store: &cancellables)
    }
    
    var body: some View {
        let conversationView = ConversationView(
            viewModel: viewModel,
            messageSentListener: self
        )
        let peripheralsView = PeripheralsView(
            viewModel: viewModel,
            peripheralConnectedListener: self
        )
        let isRemotePeripheralNil = Binding(get: {viewModel.remotePeripheral != nil}, set: { _ in })
        
        NavigationView {
            ZStack {
                peripheralsView
                NavigationLink(
                    destination: conversationView.onDisappear { onRemotePeripheralDisconnect() },
                    isActive: isRemotePeripheralNil) { EmptyView() }
            }
        }
    }
}

extension ContentView {
    func setPublishers(store cancellables: inout Set<AnyCancellable>) {
        bluetoothManager.connectedPeripheralPublisher
            .sink(receiveValue: onConnect(peripheral:))
            .store(in: &cancellables)
        bluetoothManager.peripheralPublisher
            .sink(receiveValue: onFind(new:))
            .store(in: &cancellables)
        bluetoothManager.disconnectedPeripheralPublisher
            .sink(receiveValue: onDisconnect(peripheral:))
            .store(in: &cancellables)
        bluetoothManager.messageReceivedPublisher
            .sink(receiveValue: received(a:))
            .store(in: &cancellables)
    }
    
    func onConnect(peripheral: CBPeripheral) {
        viewModel.peripheralWasConnected(
            id: peripheral.identifier.uuidString,
            name: peripheral.name,
            description: peripheral.description
        )
    }
    
    func onFind(new peripheral: CBPeripheral) {
        viewModel.addNewDevice(
            name: peripheral.name,
            description: peripheral.description,
            uuid: peripheral.identifier
        )
    }
    
    func onDisconnect(peripheral: CBPeripheral) {
        viewModel.currentPeripheralWasDisconnected()
    }
    
    func received(a message: String) {
        viewModel.receive(a: message)
    }
}

extension ContentView: OnPeripheralConnectedListener {
    func onPeripheralConnect(with id: String) {
        bluetoothManager.connectPeripheral(with: id)
    }
}

extension ContentView: OnRemotePeripheralDisconnectedListener {
    func onRemotePeripheralDisconnect() {
        bluetoothManager.disconnectCurrentPeripheral()
    }
}

extension ContentView: OnMessageSentListener {
    func send(message: String) {
        bluetoothManager.send(a: message)
        viewModel.send(a: message)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: MockMessagesViewModel().eraseToAnyItemViewModel())
    }
}
