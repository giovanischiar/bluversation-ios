//
//  MessengerViewModel.swift
//  viewmodel
//
//  Created by Giovani Schiar on 22/08/22.
//

import Foundation
import Combine

class MessengerViewModel: ObservableObject {
    private let messengerRepository: MessengerRepository
        
    private var cancellables: Set<AnyCancellable> = []
    @Published private(set) var contacts: Array<ContactViewData> = []
    @Published private(set) var clientContact: ContactViewData? = nil
    @Published private(set) var remoteContact: ContactViewData? = nil
    @Published private(set) var currentConversation: [MessageViewData] = []
    @Published private(set) var messages: [(ContactViewData, MessageViewData)] = []
    @Published var showContactsList = false
    
    init(messengerRepository: MessengerRepository) {
        self.messengerRepository = messengerRepository
        registerForNewMessagesAndContacts()
    }
    
    private func registerForNewMessagesAndContacts() {
        messengerRepository
            .contactsPublisher
            .sink { contact in self.addNewContact(contact: contact) }
            .store(in: &self.cancellables)
        
        messengerRepository.messagesPublisher.sink { (contact, message) in
            self.receive(from: contact, a: message)
        }
        .store(in: &self.cancellables)
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
        showContactsList = false
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
            let clientContact = contacts.filter({ $0.id == id }).first
            print("connecting \(clientContact?.name ?? "null")")
            self.clientContact = clientContact
        }
    }
    
    func send(a message: String) {
        messengerRepository.send(a: message)
    }
}
