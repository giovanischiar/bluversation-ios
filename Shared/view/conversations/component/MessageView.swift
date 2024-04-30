//
//  MessageView.swift
//  view.messages.component
//
//  Created by Giovani Schiar on 17/04/24.
//

import SwiftUI

struct MessageView: View {
    private var contact: ContactViewData
    private var lastMessage: MessageViewData?
    private var isSelected: Bool
    private var onTap: () -> Void
        
    init(
        contact: ContactViewData,
        lastMessage: MessageViewData?,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) {
        self.contact = contact
        self.lastMessage = lastMessage
        self.onTap = onTap
        self.isSelected = isSelected
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 50, height: 50)
                VStack {
                    HStack {
                        Text(contact.name)
                        Spacer()
                    }
                    HStack {
                        Text(lastMessage?.content ?? "I decided to go to one last mystery island before bed and ended up on shark island for the first time!")
                            .lineLimit(1)
                        Spacer()
                    }
                }
            }
        }
        .background(isSelected ? Color.gray/*("#DEE7E7")*/ : nil)
        .onTapGesture { onTap() }
    }
}
