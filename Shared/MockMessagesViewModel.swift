//
//  MockMessagesViewModel.swift
//  slowpoke
//
//  Created by Giovani Schiar on 24/08/22.
//

import Foundation

class MockMessagesViewModel: ViewModel {
    @Published var peripherals = [
        PeripheralViewData(id: UUID().uuidString, name: "Alex", description: "Mozinho")
    ]
    @Published var clientPeripheral: PeripheralViewData? = nil
    @Published var remotePeripheral: PeripheralViewData? = nil
    @Published var messages = [
        MessageViewData(sent: false, content: "Oi"),
        MessageViewData(sent: true, content: "Oi"),
        MessageViewData(sent: false, content: "Tudo bem?"),
        MessageViewData(sent: true, content: "Tudo Ótimo e você?"),
        MessageViewData(sent: false, content: "Também"),
        MessageViewData(sent: true, content: "..."),
    ]
    func addNewDevice(name: String?, description: String, uuid: UUID) {}
    func peripheralWasToogled(with id: String) {
        clientPeripheral = peripherals.first!
    }
    func peripheralWasConnected(id: String, name: String?, description: String) {
        remotePeripheral = peripherals.first!
    }
    func currentPeripheralWasDisconnected() {}
    func receive(a message: String) {}
    func send(a message: String) {}
}
