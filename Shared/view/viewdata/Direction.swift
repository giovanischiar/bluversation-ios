//
//  Direction.swift
//  slowpoke
//
//  Created by Giovani Schiar on 30/08/22.
//

import protocol SwiftUI.View
import struct SwiftUI.Color
import struct SwiftUI.HorizontalAlignment
import struct SwiftUI.Spacer
import struct SwiftUI.HStack
import CoreGraphics

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
    
    func toPaddingStart() -> CGFloat {
        if self == .right { return Dimens.message_balloon_end_margin }
        return Dimens.message_balloon_start_margin + Dimens.triangle_size
    }
    
    func toPaddingEnd() -> CGFloat {
        if self == .left { return Dimens.message_balloon_end_margin }
        return Dimens.message_balloon_start_margin + Dimens.triangle_size
    }
    
    func toHorizontalAligment() -> HorizontalAlignment {
        if self == .left { return .leading }
        return .trailing
    }
    
    func toLeadingSpacer() -> some View {
        return HStack {
            if self == .right {
                Spacer().frame(width: Dimens.message_balloon_end_margin)
                Spacer()
            } else {
                Spacer().frame(width: Dimens.message_balloon_start_margin + Dimens.triangle_size)
            }
        }
    }
    
    func toTrailingSpacer() -> some View {
        return HStack {
            if self == .left {
                Spacer().frame(width: Dimens.message_balloon_end_margin)
                Spacer()
            } else {
                Spacer().frame(width: Dimens.message_balloon_start_margin + Dimens.triangle_size)
            }
        }
    }
}




