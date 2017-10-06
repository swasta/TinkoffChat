//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol DataManagerDelegate: class {
    func didUpdate(_ onlineConversations: [Conversation], _ offlineConversations: [Conversation])
}

class DataManager {
    
    func getConversations(online: Bool) -> [Conversation] {
        if online {
            return Array(onlineConversations.values)
        } else {
            return Array(offlineConversations.values)
        }
    }

    weak var delegate: DataManagerDelegate?
    
    private lazy var offlineConversations = generateConversations(online: false, numberOfMessages: numberOfMessages)
    private lazy var onlineConversations = generateConversations(online: true, numberOfMessages: numberOfMessages)
    
    func update(_ conversation: Conversation) {
        if conversation.isOnline {
            onlineConversations[conversation.id] = conversation
        } else {
            offlineConversations[conversation.id] = conversation
        }
        delegate?.didUpdate(Array(onlineConversations.values), Array(offlineConversations.values))
    }
    
    private let numberOfMessages = 6
    
    private let names = [
        "Anna Furrow",
        "Jane Nyland",
        "Bob Janzen",
        "Carole Ahlers",
        "Erica Wolfram",
        "Dan Stinger",
        "Bryce Broadway",
        "Mark Spencer",
        "Jake Middletown",
        "Brad Miles"
    ]
    
    private let standardMessages: [Message] = [
        Message(type: .incoming, text: "?"), // 1 character
        Message(type: .outgoing, text: "!"), // 1 character
        Message(type: .incoming, text: "Have any plans for next month?"), // 30 characters
        Message(type: .outgoing, text: "We should figure out our trip!"), // 30 characters
        Message(type: .incoming, text: "Let's do it! Well, I've always wanted to travel to Paris, but haven't been there so far... I heard there are a lot of museums and historical places. We definitely should check out Louvre and the Eiffel Tower, because these are the most famous tourist attractions not only in France, but in Europe too"), // 300 characters
        Message(type: .outgoing, text: "OK, sounds great! I'll start organising the flight tickets. I'll tell you as soon as the tickets are bought. Probably, you should think if you want to take someone with you. There is a chance we will be able to visit the most famous amusement park in the world, so the company definitely won't hurt😉") // 300 characters
    ]
    
    private var randomLastMessageDate: Date {
        return Date().addingTimeInterval(TimeInterval(-60 * Int(arc4random_uniform(60 * 48))))
    }
    
    private func generateConversations(online: Bool, numberOfMessages: Int) -> [String: Conversation] {
        var conversations = [String: Conversation]()
        for (index, name) in names.enumerated() {
            let numberOfMessages = Int(arc4random_uniform(UInt32(self.numberOfMessages + 1)))
            let messages = Array(standardMessages[0..<numberOfMessages])
            var hasUnreadMessages = false
            var lastMessageDate: Date? = nil
            if !messages.isEmpty {
                let lastMessageIsIncoming = messages.last?.type == .incoming
                hasUnreadMessages = lastMessageIsIncoming
                lastMessageDate = randomLastMessageDate
            }
            let conversation = Conversation(id: String(index), name: name, messages: messages, isOnline: online, hasUnreadMessages: hasUnreadMessages, lastMessageDate: lastMessageDate)
            conversations[conversation.id] = conversation
        }
        return conversations
    }
}
