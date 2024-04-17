//
//  ArrayExtensions.swift
//  viewmodel.util
//
//  Created by Giovani Schiar on 26/08/22.
//

extension Array where Array.Element == Message {
    func toViewData() -> [MessageViewData] {
        return map { $0.toViewData() }
    }
}

extension Array where Array.Element == MessageViewData {
    func lastIndexDirection(index: Int) -> Direction {
        if index == 0 { return !self[index].direction }
        return self[index - 1].direction
    }
}

extension Array where Array.Element == (Contact, Message) {
    func toViewData() -> [(ContactViewData, MessageViewData)] {
        return map {($0.toViewData(), $1.toViewData())}
    }
}
