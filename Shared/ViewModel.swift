//
//  ViewModel.swift
//  slowpoke
//
//  Created by Giovani Schiar on 24/08/22.
//

import SwiftUI
import Combine

protocol ViewModel: ObservableObject {
    var peripherals: Array<PeripheralViewData> { get }
    var clientPeripheral: PeripheralViewData? { get }
    var remotePeripheral: PeripheralViewData? { get }
    var messages: [MessageViewData] { get }
    func addNewDevice(name: String?, description: String, uuid: UUID)
    func peripheralWasToogled(with id: String)
    func peripheralWasConnected(id: String, name: String?, description: String)
    func currentPeripheralWasDisconnected()
    func receive(a message: String)
    func send(a message: String)
}

extension ViewModel {
   func eraseToAnyItemViewModel() -> AnyViewModel {
       AnyViewModel(wrapping: self)
   }
}

class AnyViewModel: ViewModel {
    var peripherals: Array<PeripheralViewData> { peripheralsGetter() }
    private let peripheralsGetter: () -> Array<PeripheralViewData>
    var clientPeripheral: PeripheralViewData? { clientPeripheralGetter() }
    private let clientPeripheralGetter: () -> PeripheralViewData?
    var remotePeripheral: PeripheralViewData? { remotePeripheralGetter() }
    private let remotePeripheralGetter: () -> PeripheralViewData?
    var messages: Array<MessageViewData> { messagesGetter() }
    private let messagesGetter: () -> Array<MessageViewData>
    
    private let addNewDevicer: (_ id: String?, _ description: String, _ uuid: UUID) -> Void
    private let peripheralWasToogledr: (_ id: String) -> Void
    private let peripheralWasConnectedr: (_ id: String, _ name: String?, _ description: String) -> Void
    private let currentPeripheralWasDisconnectedr: () -> Void
    private let receiver: (_ message: String) -> Void
    private let sendr: (_ message: String) -> Void
     
    let objectWillChange: AnyPublisher<Void, Never>
    
    init<T: ViewModel>(wrapping viewModel: T) {
        self.objectWillChange = viewModel
            .objectWillChange
            .map { _ in () }
            .eraseToAnyPublisher()
        self.peripheralsGetter = { viewModel.peripherals }
        self.clientPeripheralGetter = { viewModel.clientPeripheral }
        self.remotePeripheralGetter = { viewModel.remotePeripheral }
        self.messagesGetter = { viewModel.messages }
        
        self.addNewDevicer = viewModel.addNewDevice
        self.peripheralWasToogledr = viewModel.peripheralWasToogled
        self.peripheralWasConnectedr = viewModel.peripheralWasConnected
        self.currentPeripheralWasDisconnectedr = viewModel.currentPeripheralWasDisconnected
        self.receiver = viewModel.receive
        self.sendr = viewModel.send
    }
    
    func addNewDevice(name: String?, description: String, uuid: UUID) { addNewDevicer(name, description, uuid) }
    func peripheralWasToogled(with id: String) { peripheralWasToogledr(id) }
    func peripheralWasConnected(id: String, name: String?, description: String) { peripheralWasConnectedr(id, name, description) }
    func currentPeripheralWasDisconnected() { currentPeripheralWasDisconnectedr() }
    func receive(a message: String) { receiver(message) }
    func send(a message: String) { sendr(message) }
}
