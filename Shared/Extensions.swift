//
//  Extensions.swift
//  slowpoke
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
