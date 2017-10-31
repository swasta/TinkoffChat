//
//  ConversationsListTableDataSource.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IConversationsListTableDataSource: UITableViewDataSource {
    func setup(dataSource: [ConversationViewModel])
    func conversation(for indexPath: IndexPath) -> ConversationViewModel
}

class ConversationsListTableDataSource: NSObject, IConversationsListTableDataSource {
    private var conversations = [[ConversationViewModel]]()
    private let headerTitles = ["Online", "History"]
    
    // MARK: - API
    
    func conversation(for indexPath: IndexPath) -> ConversationViewModel {
        return conversations[indexPath.section][indexPath.row]
    }
    
    func setup(dataSource: [ConversationViewModel]) {
        let onlineConversations = dataSource.filter { $0.isOnline }
        let offlineConversations = dataSource.filter { !$0.isOnline }
        conversations = [sort(onlineConversations), sort(offlineConversations)]
    }
    
    // MARK: - Private methods
    
    private func sort(_ conversations: [ConversationViewModel]) -> [ConversationViewModel] {
        let sortedConversationsWithLastMessageDate = conversations
            .filter { $0.lastMessageDate != nil }
            .sorted {$0.lastMessageDate! > $1.lastMessageDate!}
        let sortedConversationsWithoutLastMessageDate = conversations
            .filter { $0.lastMessageDate == nil }
            .sorted { $0.userName > $1.userName }
        return sortedConversationsWithLastMessageDate + sortedConversationsWithoutLastMessageDate
    }
}

// MARK: - UITableViewDataSource

extension ConversationsListTableDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return conversations[section].count == 0 ? nil : headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath)
        guard let conversationCell = cell as? ConversationCellConfiguration & UITableViewCell else {
            assertionFailure("Wrong cell type in ConversationsListViewController")
            return cell
        }
        let conversation = self.conversation(for: indexPath)
        conversationCell.name = conversation.userName
        conversationCell.message = conversation.messages.last?.text
        conversationCell.date = conversation.lastMessageDate
        conversationCell.online = conversation.isOnline
        conversationCell.hasUnreadMessages = conversation.hasUnreadMessages
        return conversationCell
    }
}
