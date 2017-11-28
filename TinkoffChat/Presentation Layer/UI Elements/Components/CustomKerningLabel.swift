//
//  CustomKerningLabel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

@IBDesignable class CustomKerningLabel: UILabel {
    @IBInspectable var characterSpacing: CGFloat = 1 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSAttributedStringKey.kern,
                                          value: self.characterSpacing,
                                          range: NSRange(location: 0, length: attributedString.length - 1))
            self.attributedText = attributedString
        }
    }
}
