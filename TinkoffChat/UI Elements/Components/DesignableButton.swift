//
//  DesignableButton.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 01/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton, DesignableCorners, DesignableBorder {
    
    // MARK: - Corners
    @IBInspectable var cornerRadius: CGFloat = .nan {
        didSet {
            setupCorners()
        }
    }
    
    @IBInspectable var isCircular: Bool = false {
        didSet {
            setupCorners()
        }
    }
    
    @IBInspectable var cornerRadiusFraction: CGFloat = .nan {
        didSet {
            setupCorners()
        }
    }
    
    // MARK: - Border
    @IBInspectable open var borderWidth: CGFloat = CGFloat.nan {
        didSet {
            setupBorder()
        }
    }
    
    @IBInspectable open var borderColor: UIColor? = nil {
        didSet {
            setupBorder()
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCorners()
        setupBorder()
    }
}
