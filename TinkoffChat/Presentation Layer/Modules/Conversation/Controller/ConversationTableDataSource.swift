//
//  ConversationTableDataSource.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IConversationTableDataSource: UITableViewDataSource {
    func setup(dataSource: [MessageViewModel])
}

class ConversationTableDataSource: NSObject, IConversationTableDataSource {
    private enum CellIdentifier {
        static let incomingCellIdentifier = "Incoming Cell"
        static let outgoingCellIdentifier = "Outgoing Cell"
    }
    
    private var messages = [MessageViewModel]()
    
    func setup(dataSource: [MessageViewModel]) {
        self.messages = dataSource
    }
}

extension ConversationTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let identifier = message.type == .incoming ? CellIdentifier.incomingCellIdentifier : CellIdentifier.outgoingCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let messageCell = cell as? MessageCellConfiguration & UITableViewCell else {
            assertionFailure("Wrong cell type")
            return cell
        }
        messageCell.message = message.text
        return cell
    }
}
