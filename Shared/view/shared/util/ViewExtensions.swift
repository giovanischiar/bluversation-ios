//
//  ViewExtensions.swift
//  view.shared.util
//
//  Created by Giovani Schiar on 24/08/22.
//

import Combine
import SwiftUI

extension View {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
#if os(iOS)
        Publishers
            .Merge(
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardDidShowNotification)
                    .map { _ in true },
                NotificationCenter
                    .default
                    .publisher(for: UIResponder.keyboardDidHideNotification)
                    .map { _ in false })
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
#else
        Empty()
            .eraseToAnyPublisher()
#endif
    }
}

extension Color {
    init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0)
    }
    
    init(rgb: Int) {
        self.init(red: rgb >> 16 & 0xFF, green: rgb >> 8 & 0xFF, blue: rgb & 0xFF)
   }
}
