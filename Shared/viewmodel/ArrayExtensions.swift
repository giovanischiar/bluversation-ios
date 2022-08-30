//
//  ArrayExtensions.swift
//  viewmodel
//
//  Created by Giovani Schiar on 26/08/22.
//

extension Array where Array.Element == Message {
    func toViewData() -> [MessageViewData] {
        return map { $0.toViewData() }
    }
}

