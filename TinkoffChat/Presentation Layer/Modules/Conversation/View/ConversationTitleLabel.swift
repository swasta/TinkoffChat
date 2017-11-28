//
//  ConversationTitleLabel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationTitleLabel: UILabel {
    private let animationDuration: TimeInterval = 1
    private let onlineScale: CGFloat = 1.1
    private let onlineColor = UIColor.green
    private let offlineColor = UIColor.black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        didSet {
            sizeToFit()
        }
    }
    
    var isOnline: Bool = false {
        didSet {
            if isOnline != oldValue {
                animateStateTo(online: isOnline)
            }
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let sizeWithoutScaling =  super.sizeThatFits(size)
        return sizeWithoutScaling.applying(CGAffineTransform(scaleX: onlineScale, y: onlineScale))
    }
    
    private func animateStateTo(online: Bool) {
        let transform = online ? CGAffineTransform(scaleX: onlineScale, y: onlineScale) : .identity
        let color = online ? onlineColor : offlineColor
        UIView.transition(with: self, duration: animationDuration, options: [.transitionCrossDissolve], animations: {
            self.transform = transform
            self.textColor = color
        })
    }
}
