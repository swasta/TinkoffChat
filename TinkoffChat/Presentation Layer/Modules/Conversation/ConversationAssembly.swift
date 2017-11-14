//
//  ConversationAssembly.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class ConversationAssembly {
    private let communicationService: ICommunicationService
    private let conversationStorageService: IConversationStorageService
    
    init(_ communicationService: ICommunicationService,
         _ conversationStorageService: IConversationStorageService) {
        self.communicationService = communicationService
        self.conversationStorageService = conversationStorageService
    }
    
    func assembly(_ conversationViewController: ConversationViewController, conversationID: String) {
        let model = getConversationModel(communicationService, conversationID: conversationID)
        model.delegate = conversationViewController
        conversationViewController.setDependencies(model)
    }
    
    private func getConversationModel(_ communicationService: ICommunicationService, conversationID: String) -> ConversationModel {
        return ConversationModel(communicationService: communicationService,
                                 conversationStorageService: conversationStorageService,
                                 conversationID: conversationID)
    }
}
