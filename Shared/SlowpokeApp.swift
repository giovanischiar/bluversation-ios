//
//  slowpokeApp.swift
//  Shared
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI
import CoreBluetooth
import Combine

@main
struct SlowpokeApp: App {
    private let viewModel: MessagesViewModel
    private var bluetoothManager: BluetoothManager = BluetoothManager()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        viewModel = MessagesViewModel()
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
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: viewModel,
                peripheralConnectedListener: self,
                peripheralDisconnectedListener: self,
                messageSentListener: self
            )
        }
    }
}

extension SlowpokeApp {
    func onConnect(peripheral: CBPeripheral) {
        viewModel.peripheralWasConnected(
            id: peripheral.identifier.uuidString,
            name: peripheral.name,
            description: peripheral.description
        )
    }
    
    func onDisconnect(peripheral: CBPeripheral) {
        viewModel.currentPeripheralWasDisconnected()
    }
    
    func received(a message: String) {
        viewModel.receive(a: message)
    }
}

extension SlowpokeApp: OnPeripheralConnectedListener {
    func onPeripheralConnect(with id: String) {
        bluetoothManager.connectPeripheral(with: id)
    }
}

extension SlowpokeApp: OnRemotePeripheralDisconnectedListener {
    func onRemotePeripheralDisconnect() {
        bluetoothManager.disconnectCurrentPeripheral()
    }
}

extension SlowpokeApp: OnPeripheralFoundListener {
    func onFind(new peripheral: CBPeripheral) {
        viewModel.addNewDevice(
            name: peripheral.name,
            description: peripheral.description,
            uuid: peripheral.identifier
        )
    }
}

extension SlowpokeApp: OnMessageSentListener {
    func send(message: String) {
        bluetoothManager.send(a: message)
        viewModel.send(a: message)
    }
}
