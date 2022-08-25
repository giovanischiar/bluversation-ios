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
    @Published private(set) var messages: [MessageViewData] = []
    
    init(messengerRepository: MessengerRepository = BluetoothMessengerRepository()) {
        self.messengerRepository = messengerRepository
        registerForContacts()
    }
    
    private func registerForContacts() {
        messengerRepository.registerForContacts(callback: addNewContact(id:name:description:))
    }
    
    private func addNewContact(id: String, name: String?, description: String) {
        let name = name ?? "no name"
        let peripheralViewData = ContactViewData(id: id, name: name, description: description)
        if !contacts.contains(peripheralViewData) {
            contacts.append(peripheralViewData)
        } else {
            guard let index = contacts.firstIndex(of: peripheralViewData) else { return }
            contacts[index] = peripheralViewData
        }
    }
    
    func connectClientContact() {
        guard let id = clientContact?.id else { return }
        messengerRepository.connectContact(with: id, callback: contactWasConnected(id: name: description:))
    }
    
    private func contactWasConnected(id: String, name: String?, description: String) {
        clientContact = nil
        remoteContact = ContactViewData(id: id, name: name ?? "no name", description: description)
        messengerRepository.registerForMessages(callback: receive(a:))
    }
    
    private func receive(a message: String) {
        messages.append(MessageViewData(sent: false, content: message))
    }
    
    func disconnectRemoteContact() {
        messages.removeAll()
        messengerRepository.disconnectRemoteContact(callback: contactWasDisconnected(id: name: description:))
    }
    
    private func contactWasDisconnected(id: String, name: String?, description: String) {
        remoteContact = nil
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
        messages.append(MessageViewData(sent: true, content: message))
    }
}
