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
    
    // MARK: - Common components
    private lazy var communicationService: ICommunicationService = {
        let messageEncoder = MessageEncoder(IdentifierGenerator())
        let communicator = MultipeerCommunicator(MessageHandler(encoder: messageEncoder, decoder: MessageDecoder()))
        let communicationService = CommunicationService(communicator, storageManager)
        communicator.delegate = communicationService
        return communicationService
    }()
    
    private lazy var conversationStorageService: IConversationStorageService = {
        return ConversationStorageService(storageManager: storageManager)
    }()
    
    private let storageManager = StorageManager(CoreDataStack(), IdentifierGenerator())
    
    // MARK: - Assemblies
    lazy var conversationsListAssembly: ConversationsListAssembly = {
        let conversationsListAssembly = ConversationsListAssembly(self, communicationService, conversationStorageService)
        return conversationsListAssembly
    }()

    lazy var conversationAssembly: ConversationAssembly = {
        let communicationAssembly = ConversationAssembly(communicationService, conversationStorageService)
        return communicationAssembly
    }()

    lazy var profileAssembly = ProfileAssembly(storageManager)
}
