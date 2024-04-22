//
//  Conversation.swift
//  model
//
//  Created by Giovani Schiar on 18/04/24.
//

import Foundation

struct Conversation {
    let contact: Contact
    var messages: [Message]
}

extension Conversation {
    mutating func append(a message: Message) {
        self.messages.append(message)
    }
}
