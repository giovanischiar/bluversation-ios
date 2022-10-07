//
//  MessengerTech.swift
//  messenger
//
//  Created by Giovani Schiar on 06/10/22.
//

import struct Combine.AnyPublisher

protocol MessengerTech {
    var contactPublisher: AnyPublisher<Contact, Never> { get }
    var connectedContactPublisher: AnyPublisher<Contact, Never> { get }
    var disconnectedContactPublisher: AnyPublisher<Contact, Never> { get }
    var messagesPublisher: AnyPublisher<(Contact, Message), Never> { get }
    
    func connectContact(with id: String)
    func disconnectCurrentContact()
    func send(a message: String)
}
