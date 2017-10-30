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
    
    init(_ communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    func assembly(_ conversationViewController: ConversationViewController, conversation: ConversationViewModel) {
        let model = getConversationModel(communicationService, conversation: conversation)
        communicationService.delegate = model
        let conversationsTableDataSource = ConversationTableDataSource()
        conversationsTableDataSource.setup(dataSource: conversation.messages)
        model.delegate = conversationViewController
        let conversationsTableDelegate = ConversationTableDelegate()
        conversationsTableDelegate.setup(dataSource: conversation.messages)
        conversationViewController.setDependencies(conversationsTableDataSource, conversationsTableDelegate, model)
    }
    
    private func getConversationModel(_ communicationService: ICommunicationService, conversation: ConversationViewModel) -> ConversationModel {
        return ConversationModel(communicationService: communicationService, conversation: conversation)
    }
}
