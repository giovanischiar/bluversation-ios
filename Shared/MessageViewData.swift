//
//  MessageViewData.swift
//  slowpoke
//
//  Created by Giovani Schiar on 23/08/22.
//

import Foundation

struct MessageViewData {
    let sent: Bool
    let content: String
    let id: UUID = UUID()
}

extension MessageViewData: Identifiable {}
extension MessageViewData: Hashable {}
