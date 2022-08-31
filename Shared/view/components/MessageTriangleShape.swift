//
//  MessageTriangleShape.swift
//  components
//
//  Created by Giovani Schiar on 30/08/22.
//

import protocol SwiftUI.Shape
import struct SwiftUI.Path
import struct SwiftUI.CGRect
import struct SwiftUI.CGPoint

struct MessageTriangleShape: Shape {
    private let direction: Direction
    
    init(direction: Direction) { self.direction = direction }
    
    func path(in rect: CGRect) -> Path {
        let offset = direction == .right ? rect.width - ((2 * Dimens.message_balloon_start_margin) + (2 * Dimens.triangle_size)) : 0
        return Path { path in
            path.move(to: CGPoint(x: offset + Dimens.message_balloon_start_margin, y: 0))
            path.addLine(to: CGPoint(x: offset + Dimens.message_balloon_start_margin + (2 * Dimens.triangle_size), y: 0))
            path.addLine(to: CGPoint(x: offset + (Dimens.triangle_size+Dimens.message_balloon_start_margin), y: Dimens.triangle_size))
            path.addLine(to: CGPoint(x: offset + Dimens.message_balloon_start_margin, y: 0))
            path.closeSubpath()
        }
    }
}
