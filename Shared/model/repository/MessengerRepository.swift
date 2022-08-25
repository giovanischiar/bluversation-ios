//
//  MessengerRepository.swift
//  repository
//
//  Created by Giovani Schiar on 24/08/22.
//

protocol MessengerRepository {
    func registerForContacts(callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void)
    func registerForMessages(callback: @escaping (_ message: String) -> Void)
    func connectContact(with id: String, callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void)
    func disconnectRemoteContact(callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void)
    func send(a message: String)
}
