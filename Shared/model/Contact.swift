//
//  Contact.swift
//  model
//
//  Created by Giovani Schiar on 26/08/22.
//

import struct Foundation.UUID

struct Contact: Hashable {
    let id: UUID
    let name: String?
}
