//
//  MessagesViewModel.swift
//  slowpoke
//
//  Created by Giovani Schiar on 22/08/22.
//

import Foundation
import SwiftUI

class MessagesViewModel: ObservableObject {
    @Published private(set) var peripherals: Array<PeripheralViewData> = []
    @Published private(set) var clientPeripheral: PeripheralViewData? = nil
    @Published private(set) var remotePeripheral: PeripheralViewData? = nil
    @Published private(set) var messages: [MessageViewData] = []
    
    func addNewDevice(name: String?, description: String, uuid: UUID) {
        guard name != nil else { return }
        let peripheralViewData = PeripheralViewData(id: uuid.uuidString, name: name ?? "no name", description: description)
        if !peripherals.contains(peripheralViewData) {
            peripherals.append(peripheralViewData)
        } else {
            guard let index = peripherals.firstIndex(of: peripheralViewData) else { return }
            peripherals[index] = peripheralViewData
        }
    }
    
    func peripheralWasToogled(with id: String) {
        if(clientPeripheral?.id == id) {
            clientPeripheral = nil
        } else {
            clientPeripheral = peripherals.filter({ $0.id == id }).first
        }
    }
    
    func peripheralWasConnected(id: String, name: String?, description: String) {
        remotePeripheral = PeripheralViewData(id: id, name: name ?? "no name", description: description)
    }
    
    func currentPeripheralWasDisconnected() {
        remotePeripheral = nil
    }
    
    func receive(a message: String) {
        messages.append(MessageViewData(sent: false, content: message))
    }
    
    func send(a message: String) {
        messages.append(MessageViewData(sent: true, content: message))
    }
}
