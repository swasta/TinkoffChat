//
//  MessageLabel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class MessageLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        configureFont()
    }
    
    private func configureFont() {
        font = UIFont(name: "SFUIDisplay-Regular", size: font.pointSize)
    }
}
