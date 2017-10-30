//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var name: String? { get set }
    var message: String? { get set }
    var date: String? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
    
    func applyFontStyle()
}
