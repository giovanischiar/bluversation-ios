//
//  MessageViewData.swift
//  view.shared.viewdata
//
//  Created by Giovani Schiar on 23/08/22.
//

import Foundation

struct MessageViewData {
    let direction: Direction
    let content: String
    let id: UUID = UUID()
}

extension MessageViewData: Identifiable {}
extension MessageViewData: Hashable {}
