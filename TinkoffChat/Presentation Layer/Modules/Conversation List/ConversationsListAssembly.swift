//
//  ConversationsListAssembly.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListAssembly {
    private let rootAssembly: IRootAssembly
    private let communicationService: ICommunicationService
    private let conversationStorageService: IConversationStorageService
    
    init(_ rootAssembly: IRootAssembly,
         _ communicationService: ICommunicationService,
         _ conversationStorageService: IConversationStorageService) {
        self.rootAssembly = rootAssembly
        self.communicationService = communicationService
        self.conversationStorageService = conversationStorageService
    }
    
    func assembly(_ conversationsListViewController: ConversationsListViewController) {
        let model = getConversationsListModel()
        conversationsListViewController.setDependencies(rootAssembly, model)
    }
    
    // MARK: - Private methods
    
    private func getConversationsListModel() -> IConversationsListModel {
        let conversationsListModel = ConversationsListModel(communicationService: communicationService,
                                                            conversationStorageService: conversationStorageService)
        return conversationsListModel
    }
}
