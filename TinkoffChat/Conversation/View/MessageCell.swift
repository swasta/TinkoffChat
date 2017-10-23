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
    
    private static let defaultCornerRadius = 16.0
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageContainerView: UIView! {
        didSet {
            messageContainerView.clipsToBounds = true
        }
    }
    
    func mask(for type: MessageCellType) {
        let roundedRect = messageContainerView.bounds
        let maskLayer = CAShapeLayer()
        let maskPath: UIBezierPath
        switch type {
        case .incoming:
            maskPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: MessageCell.defaultCornerRadius, height: MessageCell.defaultCornerRadius))
        case .outgoing:
            maskPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: MessageCell.defaultCornerRadius, height: MessageCell.defaultCornerRadius))
        }
        maskLayer.path = maskPath.cgPath
        messageContainerView.layer.mask = maskLayer
    }
}
