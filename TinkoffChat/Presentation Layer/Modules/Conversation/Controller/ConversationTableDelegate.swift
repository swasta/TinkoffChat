//
//  ConversationTableDelegate.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 23/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IConversationTableDelegate: UITableViewDelegate {
    func setup(dataSource: [MessageViewModel])
}

class ConversationTableDelegate: NSObject, IConversationTableDelegate {
    private var messages = [MessageViewModel]()
    
    func setup(dataSource: [MessageViewModel]) {
        self.messages = dataSource
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let messageCell = cell as? MessageCell else {
            assertionFailure("Wrong cell type in ConversationTableDelegate")
            return
        }
        let message = messages[indexPath.row]
        cell.layoutIfNeeded()
        switch message.type {
        case .incoming:
            messageCell.mask(for: .incoming)
        case .outgoing:
            messageCell.mask(for: .outgoing)
        }
    }
}
