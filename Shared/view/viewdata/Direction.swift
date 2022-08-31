//
//  Direction.swift
//  slowpoke
//
//  Created by Giovani Schiar on 30/08/22.
//

import struct SwiftUI.Color

enum Direction {
    case left
    case right
}

infix operator !

extension Direction {
    static prefix func !(left: Direction) -> Direction {
        return left == .left ? .right : .left
    }
    
    func toColor() -> Color {
        return Color(rgb: self == .left ? Colors.message_received_background_color : Colors.message_sent_background_color)
    }
}

