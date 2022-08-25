//
//  PeripheralsView.swift
//  slowpoke
//
//  Created by Giovani Schiar on 23/08/22.
//

import Foundation

import SwiftUI

struct PeripheralsView: View {
    @ObservedObject var viewModel: AnyViewModel
    var peripheralConnectedListener: OnPeripheralConnectedListener
    @State var alertOpened = false
    
    var body: some View {
        List {
            ForEach(viewModel.peripherals) { item in
                HStack {
                    Text(item.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Button("Connect") { onPeripheralClick(with: item.id); alertOpened = true }
                }
            }
        }
        .alert(isPresented: $alertOpened) {
            Alert(
                title: Text("Connect to \(viewModel.clientPeripheral?.name ?? "")?"),
                message: Text(""),
                primaryButton: .default(Text("Connect"), action: {
                    guard let id = viewModel.clientPeripheral?.id else { return }
                    viewModel.peripheralWasConnected(id: "mock", name: "mock", description: "mock")
                    peripheralConnectedListener.onPeripheralConnect(with: id)
                }),
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("Peripherals")
    }
}

extension PeripheralsView: OnPeripheralClickedListener {
    func onPeripheralClick(with id: String) {
        viewModel.peripheralWasToogled(with: id)
    }
}
