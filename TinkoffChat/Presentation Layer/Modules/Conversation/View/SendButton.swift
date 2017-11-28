//
//  SendButton.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 25/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class SendButton: UIButton {
    private let enabledColor = UIColor(red: 48/255, green: 35/255, blue: 174/255, alpha: 1)
    private let disabledColor = UIColor.lightGray
    private let animationDuration = 0.5
    private let animationScaleFactor: CGFloat = 1.15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = bounds.width / 2
    }

    override var isEnabled: Bool {
        didSet {
            let colorForNewState = isEnabled ? enabledColor : disabledColor
            animateChangingStateWith(colorForNewState)
        }
    }
    
    private func animateChangingStateWith(_ color: UIColor) {
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.allowUserInteraction], animations: {
            self.backgroundColor = color
            self.transform = CGAffineTransform(scaleX: self.animationScaleFactor, y: self.animationScaleFactor)
        }) { _ in
            UIView.animate(withDuration: self.animationDuration, delay: 0, options: [.allowUserInteraction], animations: {
                self.transform = .identity
            })
        }
    }
}
