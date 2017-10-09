//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private let onlineBackgroundColor: UIColor = #colorLiteral(red: 1, green: 0.9952996139, blue: 0.816628575, alpha: 1)
    private let noMessagesText = "No messages yet"
    private let dateFormatter = DateFormatter()
    
    class var identifier: String {
        return String(describing: self)
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var message: String? {
        didSet {
            if message != nil {
                messageLabel.font = .systemFont(ofSize: messageLabel.font.pointSize)
                messageLabel.text = message
            } else {
                messageLabel.font = .italicSystemFont(ofSize: messageLabel.font.pointSize)
                messageLabel.text = noMessagesText
            }
        }
    }
    
    var date: Date? {
        didSet {
            if let date = self.date {
                if Calendar.current.compare(Date(), to: date, toGranularity: .day) == .orderedSame {
                    dateFormatter.dateFormat = "HH:mm"
                } else {
                    dateFormatter.dateFormat = "dd MMM"
                }
                dateLabel.text = dateFormatter.string(from: date)
            } else {
                dateLabel.text = ""
            }
        }
    }
    
    var online: Bool = false {
        didSet {
            backgroundColor = online ? onlineBackgroundColor : .white
        }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            if hasUnreadMessages {
                messageLabel.font = .boldSystemFont(ofSize: messageLabel.font.pointSize)
            } else if message != nil {
                messageLabel.font = .systemFont(ofSize: messageLabel.font.pointSize)
            }
        }
    }
}
