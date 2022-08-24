//
//  OnPeripheralFoundListener.swift
//  slowpoke
//
//  Created by Giovani Schiar on 22/08/22.
//

import CoreBluetooth

protocol OnPeripheralFoundListener {
    func onFind(new peripheral: CBPeripheral)
}
