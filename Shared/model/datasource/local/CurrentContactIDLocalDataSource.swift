//
//  CurrentContactIDLocalDataSource.swift
//  model.datasource.local
//
//  Created by Giovani Schiar on 17/04/24.
//

import Combine

class CurrentContactIDLocalDataSource: CurrentContactIDDataSource {
    var currentID = ""
    lazy var currentContactIDCurrentValueSubject = CurrentValueSubject<String, Never>(currentID)
    
    func retrieve() -> AnyPublisher<String, Never> {
        return currentContactIDCurrentValueSubject.eraseToAnyPublisher()
    }
    
    func update(id: String) {
        currentID = id
        currentContactIDCurrentValueSubject.send(id)
    }
}
