//
//  ConversationDataSource.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationDataSource: NSObject {
    private struct CellIdentifier {
        static let incomingCellIdentifier = "Incoming Cell"
        static let outgoingCellIdentifier = "Outgoing Cell"
    }
    
    private let conversation: Conversation
    
    init(conversation: Conversation) {
        self.conversation = conversation
        super.init()
    }
}

extension ConversationDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = conversation.messages[indexPath.row]
        message.markAsRead()
        let identifier = message.type == .incoming ? CellIdentifier.incomingCellIdentifier : CellIdentifier.outgoingCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let cell = cell as? MessageCellConfiguration {
            cell.message = message.text
        }
        return cell
    }
}
