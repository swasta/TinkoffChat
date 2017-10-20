//
//  ConversationsListDataSource.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListDataSource: NSObject {
    private var conversations = [[Conversation]]()
    
    private let communicationManager: CommunicationManager
    private let headerTitles = ["Online", "History"]
    
    init(_ communicationManager: CommunicationManager) {
        self.communicationManager = communicationManager
        super.init()
        self.update()
    }
    
    func update() {
        let onlineConversations = sort(communicationManager.getConversations(online: true))
        let offlineConversations = sort(communicationManager.getConversations(online: false))
        conversations = [onlineConversations, offlineConversations]
    }
    
    func conversation(for indexPath: IndexPath) -> Conversation {
        return conversations[indexPath.section][indexPath.row]
    }
    
    private func sort(_ conversations: [Conversation]) -> [Conversation] {
        let sortedConversationsWithLastMessageDate = conversations
            .filter { $0.lastMessageDate != nil }
            .sorted {$0.lastMessageDate! > $1.lastMessageDate!}
        let sortedConversationsWithoutLastMessageDate = conversations
            .filter { $0.lastMessageDate == nil && $0.name != nil }
            .sorted { $0.name! > $1.name! }
        let chatsWithoutDateAndName = conversations
            .filter { $0.name == nil && $0.lastMessageDate == nil }
        return sortedConversationsWithLastMessageDate + sortedConversationsWithoutLastMessageDate + chatsWithoutDateAndName
    }
}

extension ConversationsListDataSource: UITableViewDataSource {
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
        let conversationCell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as! ConversationCell
        let conversation = self.conversation(for: indexPath)
        conversationCell.name = conversation.name
        conversationCell.message = conversation.messages.last?.text
        conversationCell.date = conversation.lastMessageDate
        conversationCell.online = conversation.isOnline
        conversationCell.hasUnreadMessages = conversation.hasUnreadMessages
        return conversationCell
    }
}
