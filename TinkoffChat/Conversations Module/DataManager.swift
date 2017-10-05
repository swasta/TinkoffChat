//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class DataManager {
    private static let names = [
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
    
    static func getConversations(online: Bool) -> [Conversation] {
        return names.map { (name) -> Conversation in
            let numberOfMessages = Int(arc4random_uniform(UInt32(standardMessages.count))) // 0..10
            let messages = Array(standardMessages[0..<numberOfMessages])
            var hasUnreadMessages = false
            var lastMessageDate: Date? = nil
            if !messages.isEmpty {
                hasUnreadMessages = arc4random_uniform(2) == 0 // flip
                lastMessageDate = randomLastMessageDate
            }
            return Conversation(name: name, messages: messages, online: online, hasUnreadMessages: hasUnreadMessages, lastMessageDate: lastMessageDate)
            }
    }
    
    private static var randomLastMessageDate: Date {
        return Date().addingTimeInterval(TimeInterval(-60 * Int(arc4random_uniform(60 * 48))))
    }
    
    private static let standardMessages: [Message] = [
            Message(type: .incoming, text: "!"),
            Message(type: .incoming, text: "Do you have any plans for next week?"),
            Message(type: .outgoing, text: "We should figure out our next trip soon since the summer is almost over"),
            Message(type: .outgoing, text: "Do you have any specific idea where we should travel this time? Any wishes?"),
            Message(type: .incoming, text: "Let's do it! Well, I've always wanted to travel to Paris, but haven't been there so far... I heard there are a lot of museums and historical places. We definitely should check out Louvre and the Eiffel Tower, because these are the most famous tourist attractions not only in France, but in Europe too."),
            Message(type: .outgoing, text: "OK, sounds great! I'll start organising the flight tickets first")
        ]
}
