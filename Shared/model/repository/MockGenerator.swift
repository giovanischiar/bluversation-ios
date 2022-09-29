//
//  MockGenerator.swift
//  repository
//
//  Created by Giovani Schiar on 09/09/22.
//

import struct SwiftUI.UUID

struct MockGenerator {
    private let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec laoreet lorem quis sem congue pulvinar. Phasellus finibus purus quis nibh elementum ornare. Aliquam egestas, risus vitae pharetra ornare, orci felis commodo massa, egestas placerat ante eros ut ligula. Vivamus pulvinar neque vitae nibh auctor, ac aliquam felis consectetur. In commodo accumsan euismod. Nam laoreet pulvinar convallis. Quisque cursus sem in pellentesque pellentesque. Curabitur rhoncus neque nibh, quis lobortis nisi auctor nec. Praesent cursus mi elit, vestibulum condimentum magna consectetur vel. Aenean scelerisque pellentesque venenatis. Nam vitae dignissim orci."
    
    private let names = ["Alex Machado", "Giovani Schiar", "Samantha Daniele", "Thiago Cechetto", "Rodrigo Almeida", "Mariana Ambrogi"]
    
    private let contactsIDs: [UUID: String]
    
    init() {
        var contactsIDs: [UUID: String] = [:]
        for name in names { contactsIDs[UUID()] = name }
        self.contactsIDs = contactsIDs
    }
    
    func generateContacts() -> [UUID: Contact] {
        var newDict: [UUID: Contact] = [:]
        contactsIDs.forEach {
            newDict[$0] = Contact(id: $0, name: $1, description: "mock")
        }
        return newDict
    }
    
    func generateMessagesPerContact() -> [UUID:[Message]] {
        var messagesPerContact: [UUID:[Message]] = [:]
        for contactID in contactsIDs.keys {
            var messages: [Message] = []
            for _ in (0..<Int.random(in: 2...20)) {
                messages.append(
                    Message(
                        sent: Bool.random(),
                        content: generateMessage()
                    )
                )
            }
            messagesPerContact[contactID] = messages
        }
        return messagesPerContact
    }
    
    private func generateMessage() -> String {
        let wordsList = lorem.split(separator: " ").shuffled()
        let randomIntervalInsideWordsList = 0..<Int.random(in: 1...wordsList.count)
        var wordsListSlice = Array(wordsList[randomIntervalInsideWordsList]).map { String($0).lowercased() }
        for i in 0..<wordsListSlice.count {
            if i == 0 {
                wordsListSlice[i] = wordsListSlice[i].capitalized
                continue
            }
            
            guard let lastChar = wordsListSlice[i - 1].last else { continue }
            
            if (lastChar == ".") {
                wordsListSlice[i] = wordsListSlice[i].capitalized
                continue
            }
            
            wordsListSlice[i] = wordsListSlice[i]
        }
        
        var newMessage = wordsListSlice.joined(separator: " ")
    
        if let lastMessageChar = newMessage.last {
            if (lastMessageChar == ",") {
                newMessage = newMessage.dropLast() + "."
            } else if (lastMessageChar != ".") {
                newMessage = newMessage + "."
            }
        }
        
        return newMessage
    }
}
