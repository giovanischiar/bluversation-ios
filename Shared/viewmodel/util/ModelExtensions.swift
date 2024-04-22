//
//  ModelExtensions.swift
//  viewmodel.util
//
//  Created by Giovani Schiar on 26/08/22.
//

extension Contact {
    func toViewData() -> ContactViewData {
        return ContactViewData(id: id.uuidString, name: name ?? "no name")
    }
}

extension Message {
    func toViewData() -> MessageViewData {
        return MessageViewData(direction: sent ? .right : .left, content: content)
    }
}

extension Conversation {
    func toViewData() -> ConversationViewData {
        return ConversationViewData(contact: contact.toViewData(), messages: messages.toViewData())
    }
}
