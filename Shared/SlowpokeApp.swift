//
//  SlowpokeApp.swift
//  Shared
//
//  Created by Giovani Schiar on 20/08/22.
//

import SwiftUI

@main
struct SlowpokeApp: App {
    @ObservedObject private var viewModel = MessengerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
