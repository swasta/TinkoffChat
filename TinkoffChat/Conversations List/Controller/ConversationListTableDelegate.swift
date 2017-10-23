//
//  ConversationsListTableDelegate.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 23/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListTableDelegate: NSObject {
    
}

extension ConversationsListTableDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let conversationCell = cell as? ConversationCellConfiguration else {
            fatalError("Wrong cell type in conversation view controller")
        }
        conversationCell.applyFontStyle()
    }
}
