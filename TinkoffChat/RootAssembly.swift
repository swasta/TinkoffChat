//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IRootAssembly: class {
    var conversationsListAssembly: ConversationsListAssembly { get }
    var conversationAssembly: ConversationAssembly { get }
    var profileAssembly: ProfileAssembly { get }
}

class RootAssembly: IRootAssembly {
    // This service is used by each module of the app to keep only one communicator on the Core layer.
    private let communicationService: ICommunicationService = {
        let communicator = MultipeerCommunicator(MessageHandler(encoder: MessageEncoder(), decoder: MessageDecoder()))
        let communicationService = CommunicationService(communicator)
        communicator.delegate = communicationService
        return communicationService
    }()

    lazy var conversationsListAssembly: ConversationsListAssembly = {
        let conversationsListAssembly = ConversationsListAssembly(self, communicationService)
        return conversationsListAssembly
    }()

    lazy var conversationAssembly: ConversationAssembly = {
        let communicationAssembly = ConversationAssembly(communicationService)
        return communicationAssembly
    }()

    lazy var profileAssembly = ProfileAssembly()
}
