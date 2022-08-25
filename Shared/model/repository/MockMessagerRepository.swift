//
//  MockMessengerRepository.swift
//  repository
//
//  Created by Giovani Schiar on 24/08/22.
//

class MockMessengerRepository: MessengerRepository {
    private var contacts = [
        "mock": (id: "mock", name: "Alex Machado", description: "mock"),
        "mock1": (id: "mock1", name: "Giovani Schiar", description: "mock"),
        "mock2": (id: "mock2", name: "Samantha Danielle", description: "mock"),
        "mock3": (id: "mock3", name: "Thiago Cechetto", description: "mock"),
        "mock4": (id: "mock4", name: "Rodrigo Almeida", description: "mock"),
        "mock5": (id: "mock5", name: "Mariana Ambrogi", description: "mock"),
    ]
    private var remoteContact: (id: String, name: String, description: String)? = nil
    private var messagesSent = ["oi", "tudo bem?", "tudo ótimo", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ut nibh facilisis, dictum risus at, ornare leo. Vivamus nisl purus, sodales convallis blandit nec, placerat vitae tortor. Etiam malesuada ac massa eget mollis. Cras tellus sem, luctus vel magna et, ullamcorper dapibus lorem. Nullam semper magna orci, sit amet suscipit lorem posuere id. Mauris efficitur eget erat vitae dapibus. Nulla facilisi. Vivamus id dictum leo, non condimentum mauris. Ut feugiat bibendum magna non commodo. Nullam molestie sapien sed quam blandit, non viverra erat aliquet. Etiam iaculis arcu ac leo accumsan, id porttitor augue fringilla. Donec at erat dui. "
    ]
    
    func registerForContacts(callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void) {
        for contact in contacts.values.sorted(by: { $0.name < $1.name }) {
            callback(contact.id, contact.name, contact.description)
        }
    }
    
    func registerForMessages(callback: @escaping (_ message: String) -> Void) {
        for message in messagesSent {
            callback(message)
        }
    }
    
    func connectContact(with id: String, callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void) {
        guard let contact = contacts[id] else { return }
        remoteContact = contacts[id]
        callback(contact.id, contact.name, contact.description)
    }
    
    func disconnectRemoteContact(callback: @escaping (_ id: String, _ name: String?, _ description: String) -> Void) {
        guard let id = remoteContact?.id else { return }
        guard let name = remoteContact?.name else { return }
        guard let description = remoteContact?.description else { return }
        callback(id, name, description)
    }
    
    func send(a message: String) {
        
    }
}
