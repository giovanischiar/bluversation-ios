//
//  ContactsView.swift
//  view
//
//  Created by Giovani Schiar on 23/08/22.
//

import SwiftUI

struct ContactsView: View {
    @ObservedObject var viewModel: MessengerViewModel
    
    var body: some View {
        let isClientContactNil = Binding(get: {viewModel.clientContact != nil}, set: { _ in })
        
        List {
            ForEach(viewModel.contacts) { item in
                HStack {
                    Text(item.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Button("Connect") { viewModel.contactWasToggled(with: item.id) }
                }
            }
        }
        .alert(isPresented: isClientContactNil) {
            Alert(
                title: Text("Connect to \(viewModel.clientContact?.name ?? "")?"),
                message: Text(""),
                primaryButton: .default(Text("Connect"), action: {
                    viewModel.connectClientContact()
                }),
                secondaryButton: .cancel {
                    guard let id = viewModel.clientContact?.id else { return }
                    viewModel.contactWasToggled(with: id)
                }
            )
        }
        .navigationTitle("Contacts")
    }
}
