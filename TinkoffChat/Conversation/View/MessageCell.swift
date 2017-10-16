//
//  MessageTableViewCell.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, MessageCellConfiguration {
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    @IBOutlet private weak var messageLabel: UILabel!
}
