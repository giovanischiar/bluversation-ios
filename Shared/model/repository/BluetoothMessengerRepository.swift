//
//  BluetoothMessengerRepository.swift
//  repository
//
//  Created by Giovani Schiar on 24/08/22.
//

import Combine

class BluetoothMessengerRepository: MessengerRepository {
    var bluetoothManager = BluetoothManager()
    var cancellables: Set<AnyCancellable> = []
    
    func registerForContacts(callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void) {
        bluetoothManager.peripheralPublisher
            .sink { peripheral in
                callback(peripheral.identifier.uuidString, peripheral.name, peripheral.description)
            }
            .store(in: &cancellables)
    }
    
    func registerForMessages(callback: @escaping (_ message: String) -> Void) {
        bluetoothManager.messageReceivedPublisher
            .sink { callback($0) }
            .store(in: &cancellables)
    }
    
    func connectContact(with id: String, callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void) {
        bluetoothManager.connectedPeripheralPublisher
            .sink { peripheral in
                callback(peripheral.identifier.uuidString, peripheral.name, peripheral.description)
            }
            .store(in: &cancellables)
        bluetoothManager.connectPeripheral(with: id)
    }
    
    func disconnectRemoteContact(callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void) {
        bluetoothManager.disconnectedPeripheralPublisher.sink { peripheral in
            callback(peripheral.identifier.uuidString, peripheral.name, peripheral.description)
        }
        .store(in: &cancellables)
    }
    
    func send(a message: String) {
        bluetoothManager.send(a: message)
    }
}
