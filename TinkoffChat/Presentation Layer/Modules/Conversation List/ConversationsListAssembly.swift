//
//  ConversationsListAssembly.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListAssembly {
    private let communicationService: ICommunicationService
    
    init(_ communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    func assembly(_ conversationsListViewController: ConversationsListViewController) {
        let model = getConversationsListModel()
        model.delegate = conversationsListViewController
        let conversationsListTableDataSource = ConversationsListTableDataSource()
        let conversationsListTableDelegate = ConversationsListTableDelegate()
        conversationsListViewController.setDependencies(conversationsListTableDataSource, conversationsListTableDelegate, model)
    }
    
    // MARK: - Private methods
    
    private func getConversationsListModel() -> IConversationsListModel {
        let conversationsListModel = ConversationsListModel(communicationService: communicationService)
        communicationService.delegate = conversationsListModel
        return conversationsListModel
    }
    
    private func getMessageHandler() -> IMessageHandler {
        return MessageHandler(encoder: getMessageEncoder(), decoder: getMessageDecoder())
    }
    
    private func getMessageEncoder() -> IMessageEncoder {
        return MessageEncoder()
    }
    
    private func getMessageDecoder() -> IMessageDecoder {
        return MessageDecoder()
    }
}
