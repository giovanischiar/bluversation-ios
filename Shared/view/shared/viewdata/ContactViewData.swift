//
//  ContactViewData.swift
//  view.shared.viewdata
//
//  Created by Giovani Schiar on 22/08/22.
//

import Foundation

struct ContactViewData {
    let id: String
    let name: String
}

extension ContactViewData: Hashable {}
extension ContactViewData: Identifiable {}
extension ContactViewData: Equatable {
    static func ==(lhs: ContactViewData, rhs: ContactViewData) -> Bool {
        lhs.id == rhs.id
    }
}
