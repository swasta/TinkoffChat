//
//  ConversationTableDelegate.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 23/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationTableDelegate: NSObject {
    private let conversation: Conversation
    
    init(conversation: Conversation) {
        self.conversation = conversation
        super.init()
    }
}

extension ConversationTableDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let messageCell = cell as? MessageCell else {
            fatalError("Wrong cell type in ConversationTableDelegate")
        }
        let message = conversation.messages[indexPath.row]
        cell.layoutIfNeeded()
        switch message.type {
        case .incoming:
            messageCell.mask(for: .incoming)
        case .outgoing:
            messageCell.mask(for: .outgoing)
        }
    }
}
