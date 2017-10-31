//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var message: String? { get set }
}

class MessageCell: UITableViewCell, MessageCellConfiguration {
    enum MessageCellType {
        case incoming
        case outgoing
    }

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
        let defaultCornerRadii = CGSize(width: MessageCell.defaultCornerRadius, height: MessageCell.defaultCornerRadius)
        switch type {
        case .incoming:
            maskPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .topRight, .bottomRight], cornerRadii: defaultCornerRadii)
        case .outgoing:
            maskPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: defaultCornerRadii)
        }
        maskLayer.path = maskPath.cgPath
        messageContainerView.layer.mask = maskLayer
    }
}
