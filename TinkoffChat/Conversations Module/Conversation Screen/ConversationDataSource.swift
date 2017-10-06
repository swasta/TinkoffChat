//
//  ConversationDataSource.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsDataSource: NSObject {
    private struct CellIdentifier {
        static let incomingCellIdentifier = "Incoming Cell"
        static let outgoingCellIdentifier = "Outgoing Cell"
    }
    
    let conversation: Conversation
    
    init(conversation: Conversation) {
        self.conversation = conversation
        super.init()
    }
}

extension ConversationsDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = conversation.messages[indexPath.row]
        let identifier = message.type == .incoming ? CellIdentifier.incomingCellIdentifier : CellIdentifier.outgoingCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
        cell.message = message.text
        return cell
    }
}
