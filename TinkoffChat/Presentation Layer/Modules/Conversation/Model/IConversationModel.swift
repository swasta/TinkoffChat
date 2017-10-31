//
//  IConversationModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IConversationModel: class {
    weak var delegate: IConversationModelDelegate? { get set }
    var isEmpty: Bool { get }
    var userName: String { get }
    func send(message: String, completionHandler: (() -> Void)?)
    func markConversationAsRead()
}

protocol IConversationModelDelegate: class {
    func setup(dataSource: [MessageViewModel])
    func userChangesStatusTo(online: Bool)
}
