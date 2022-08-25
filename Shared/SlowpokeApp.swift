//
//  slowpokeApp.swift
//  Shared
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI
import Combine

@main
struct SlowpokeApp: App {
    private let viewModel: MessagesViewModel
    
    init() {
        viewModel = MessagesViewModel()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel.eraseToAnyItemViewModel())
        }
    }
}
