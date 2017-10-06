//
//  ConversationsListDataSource.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListDataSource: NSObject {
    private let onlineConversations = DataManager.getConversations(online: true)
    private let offlineConversations = DataManager.getConversations(online: false)
    
    private let firstSectionHeader = "Online"
    private let secondSectionHeader = "History"
    
    func conversation(for indexPath: IndexPath) -> Conversation {
        return indexPath.section == 0 ? onlineConversations[indexPath.row] : offlineConversations[indexPath.row]
    }
}

extension ConversationsListDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return firstSectionHeader
        case 1:
            return secondSectionHeader
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineConversations.count
        case 1:
            return offlineConversations.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversationCell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        let conversation = self.conversation(for: indexPath)
        conversationCell.name = conversation.name
        conversationCell.message = conversation.messages.last?.text
        conversationCell.date = conversation.lastMessageDate
        conversationCell.online = conversation.online
        conversationCell.hasUnreadMessages = conversation.hasUnreadMessages
        return conversationCell
    }
}
