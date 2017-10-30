//
//  IConversationsListModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 29/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IConversationsListModelDelegate: class {
    func setup(dataSource: [ConversationViewModel])
}

protocol IConversationsListModel: class {
    weak var delegate: IConversationsListModelDelegate? { get set }
    func resumeListeningToCommunicationService()
}
