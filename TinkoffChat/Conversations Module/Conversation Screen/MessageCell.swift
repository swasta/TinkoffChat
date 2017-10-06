//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
}
