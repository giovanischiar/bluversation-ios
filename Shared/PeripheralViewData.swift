//
//  PeripheralViewData.swift
//  slowpoke
//
//  Created by Giovani Schiar on 22/08/22.
//

import Foundation

struct PeripheralViewData {
    let id: String
    let name: String
    let description: String
}

extension PeripheralViewData: Hashable {}
extension PeripheralViewData: Identifiable {}
extension PeripheralViewData: Equatable {
    static func ==(lhs: PeripheralViewData, rhs: PeripheralViewData) -> Bool {
        lhs.id == rhs.id
    }
}
