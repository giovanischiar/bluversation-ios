//
//  BluetoothManager.swift
//  Shared
//
//  Created by Giovani Schiar on 20/08/22.
//

import CoreBluetooth
import Combine

class BluetoothManager: NSObject {
    private let WR_UUID = CBUUID(string: "3207f4cd-bf79-43e8-bd7a-d2ba4b176acc")
    private let WR_PROPERTIES: CBCharacteristicProperties = .write
    private let WR_PERMISSIONS: CBAttributePermissions = .writeable

    let peripheralPublisher = PassthroughSubject<CBPeripheral, Never>()
    let connectedPeripheralPublisher = PassthroughSubject<CBPeripheral, Never>()
    let disconnectedPeripheralPublisher = PassthroughSubject<CBPeripheral, Never>()
    let messageReceivedPublisher = PassthroughSubject<(CBPeripheral, String), Never>()
    let messageSentPublisher = PassthroughSubject<String, Never>()

    private var peripheralsFound: [String: CBPeripheral] = [:]
    private var connectedPeripheral: CBPeripheral?
    private var characteriticOfConnectedPeripheral: CBCharacteristic?
    
    private lazy var centralManager: CBCentralManager = {
        CBCentralManager(delegate: self, queue: nil)
    }()
    
    private lazy var peripheralManager: CBPeripheralManager = {
        CBPeripheralManager(delegate: self, queue: nil)
    }()
    
    override init() {
        super.init()
        _ = centralManager
        _ = peripheralManager
    }
    
    func connectPeripheral(with id: String) {
        guard let peripheralFound = peripheralsFound[id] else { return }
        centralManager.connect(peripheralFound)
    }
    
    func disconnectCurrentPeripheral() {
        guard let peripheral = self.connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func send(a message: String) {
        guard let characteristic = characteriticOfConnectedPeripheral else { return }
        guard let peripheral = connectedPeripheral else { return }
        let data = message.data(using: .utf8)
        messageSentPublisher.send(message)
        peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
    }
}

extension BluetoothManager: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn else { return }
        let serialService = CBMutableService(type: WR_UUID, primary: true)
        let writeCharacteristics = CBMutableCharacteristic(type: WR_UUID,
                                         properties: WR_PROPERTIES, value: nil,
                                         permissions: WR_PERMISSIONS)
        serialService.characteristics = [writeCharacteristics]
        peripheralManager.add(serialService)
        
        let advertisementData = "Slowpoke"
        peripheralManager.startAdvertising([
                CBAdvertisementDataServiceUUIDsKey: [WR_UUID],
                CBAdvertisementDataLocalNameKey: advertisementData
            ]
        )
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if let value = request.value {
                
                //here is the message text that we receive, use it as you wish.
                let messageText = String(data: value, encoding: String.Encoding.utf8) as String?
                guard let message = messageText else { return }
                print("message received!: \(messageText ?? "nil")")
                guard let whoSent = peripheralsFound[request.central.identifier.uuidString] else { return }
                messageReceivedPublisher.send((whoSent, message))
                
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn: centralManager.scanForPeripherals(withServices: [WR_UUID], options: nil)
            case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff: break
            @unknown default: break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripheralsFound[peripheral.identifier.uuidString] = peripheral
        peripheralPublisher.send(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection with \(peripheral.debugDescription) was successful!")
        connectedPeripheralPublisher.send(peripheral)
        connectedPeripheral = peripheralsFound[peripheral.identifier.uuidString]
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
        
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect to \(peripheral.debugDescription), error: \(error?.localizedDescription ?? "nil")")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Connection with \(peripheral.debugDescription) was successful disconnected!")
        disconnectedPeripheralPublisher.send(peripheral)
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral( _ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let characteristic = characteristic as CBCharacteristic
            if (characteristic.uuid.isEqual(WR_UUID)) {
                characteriticOfConnectedPeripheral = characteristic
            }
        }
    }
}
