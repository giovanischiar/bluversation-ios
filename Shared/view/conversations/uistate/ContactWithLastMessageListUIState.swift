//
//  ContactWithLastMessageUIState.swift
//  Bluversation
//
//  Created by Giovani Schiar on 10/06/24.
//

enum ContactWithLastMessageListUIState {
    case loading
    case contactWithLastMessageListLoaded([(ContactViewData, MessageViewData)])
}
