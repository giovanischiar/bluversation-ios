//
//  MessageBalloon.swift
//  components
//
//  Created by Giovani Schiar on 30/08/22.
//

import protocol SwiftUI.View
import protocol SwiftUI.ShapeStyle
import struct SwiftUI.HStack
import struct SwiftUI.Spacer
import struct SwiftUI.Text
import struct SwiftUI.Color
import struct SwiftUI.AnyView

struct MessageBalloon: View {
    private var index: Int
    private var message: MessageViewData
    private var lastMessageDirection: Direction
    
    init(index: Int, message: MessageViewData, lastMessageDirection: Direction) {
        self.index = index
        self.message = message
        self.lastMessageDirection = lastMessageDirection
    }
    
    var body: some View {
        Text(message.content)
            .padding(.all, Dimens.message_balloon_padding)
            .background(message.direction.toColor())
            .cornerRadius(Dimens.message_balloon_border_radius)
            .foregroundColor(Color(rgb: Colors.message_text_color))
            .addSpacers(direction: message.direction)
            .addTriangle(
                direction: message.direction,
                lastMessageDirection: lastMessageDirection
            )
    }
}

extension View {
    func addTriangle(direction: Direction, lastMessageDirection: Direction) -> some View {
        if (lastMessageDirection != direction) {
            let triangleColor = direction.toColor()
            let messageTriangleShape = MessageTriangleShape(direction: direction).foregroundColor(triangleColor)
            return AnyView(self.overlay(messageTriangleShape))
        }
        return AnyView(self)
    }
    
    func addSpacers(direction: Direction) -> some View {
        return HStack {
            if (direction == .right) {
                Spacer().frame(width: Dimens.message_balloon_end_margin)
                Spacer()
            } else {
                Spacer().frame(width: Dimens.message_balloon_start_margin + Dimens.triangle_size)
            }
            self
            if (direction == .left) {
                Spacer().frame(width: Dimens.message_balloon_end_margin)
                Spacer()
            } else {
                Spacer().frame(width: Dimens.message_balloon_start_margin + Dimens.triangle_size)
            }
        }
    }
}
