//
//  MessengerRepository.swift
//  repository
//
//  Created by Giovani Schiar on 24/08/22.
//

protocol MessengerRepository {
    func registerForContacts(callback: @escaping (_ contact: Contact) -> Void)
    func registerForMessages(callback: @escaping (_ message: Message) -> Void)
    func connectContact(with id: String, callback: @escaping (_ contact: Contact, _ messages: [Message]) -> Void)
    func disconnectRemoteContact(callback: @escaping (_ contact: Contact) -> Void)
    func send(a message: String)
}
