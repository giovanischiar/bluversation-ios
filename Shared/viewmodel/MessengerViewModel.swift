//
//  MessengerViewModel.swift
//  viewmodel
//
//  Created by Giovani Schiar on 22/08/22.
//

import Foundation

class MessengerViewModel: ObservableObject {
    private let messengerRepository: MessengerRepository
    
    @Published private(set) var contacts: Array<ContactViewData> = []
    @Published private(set) var clientContact: ContactViewData? = nil
    @Published private(set) var remoteContact: ContactViewData? = nil
    @Published private(set) var currentConversation: [MessageViewData] = []
    @Published private(set) var messages: [(ContactViewData, MessageViewData)] = []
    
    init(messengerTech: any MessengerTech = BluetoothMessengerTech()) {
        messengerRepository = MessengerRepository(messengerTech: messengerTech)
        messengerRepository.registerForContacts(callback: addNewContact(contact:))
        messengerRepository.registerForMessages(callback: receive(from:a:))
    }
    
    private func addNewContact(contact: Contact) {
        let contactViewData = contact.toViewData()
        if !contacts.contains(contactViewData) {
            contacts.append(contactViewData)
        } else {
            guard let index = contacts.firstIndex(of: contactViewData) else { return }
            contacts[index] = contactViewData
        }
    }
    
    func connectClientContact() {
        guard let id = clientContact?.id else { return }
        if (remoteContact != nil) {
            messengerRepository.disconnectRemoteContact(callback: contactWasDisconnected(contact:))
        } else {
            messengerRepository.connectContact(with: id, callback: contactWasConnected(contact:messages:))
        }
    }
    
    private func contactWasConnected(contact: Contact, messages: [Message]) {
        clientContact = nil
        remoteContact = contact.toViewData()
        currentConversation = messages.toViewData()
    }
    
    private func receive(from who: Contact, a message: Message) {
        messages = messengerRepository.lastMessageOfEachContact().toViewData()
        if (who.toViewData() == remoteContact) {
            currentConversation.append(message.toViewData())
        }
    }
    
    func disconnectRemoteContact() {
        messengerRepository.disconnectRemoteContact(callback: contactWasDisconnected(contact:))
    }
    
    private func contactWasDisconnected(contact: Contact) {
        remoteContact = nil
        if let id = clientContact?.id {
            messengerRepository.connectContact(with: id, callback: contactWasConnected(contact:messages:))
        }
    }
    
    func contactWasToggled(with id: String) {
        if(clientContact?.id == id) {
            clientContact = nil
        } else {
            clientContact = contacts.filter({ $0.id == id }).first
        }
    }
    
    func send(a message: String) {
        messengerRepository.send(a: message)
    }
}
