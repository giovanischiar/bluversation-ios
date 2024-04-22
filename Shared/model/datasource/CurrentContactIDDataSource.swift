//
//  CurrentContactIDDataSource.swift
//  model.datasource
//
//  Created by Giovani Schiar on 17/04/24.
//

import Foundation
import Combine

protocol CurrentContactIDDataSource {
    func retrieve() -> AnyPublisher<String, Never>
    func update(id: String)
}
