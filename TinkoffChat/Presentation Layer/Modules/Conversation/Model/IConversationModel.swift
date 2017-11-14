//
//  IConversationModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IConversationModel: class {
    weak var delegate: IConversationModelDelegate? { get set }
    var isOnline: Bool { get }
    var userName: String { get }
    func send(message: String)
    func markConversationAsRead()
    func configureWith(_ tableView: UITableView)
}

protocol IConversationModelDelegate: class {
    func userChangesStatusTo(online: Bool)
}
