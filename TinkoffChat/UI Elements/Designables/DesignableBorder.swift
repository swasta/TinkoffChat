//
//  DesignableBorder.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 01/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol DesignableBorder {
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor? { get set }
}

extension DesignableBorder where Self: UIView {
    func setupBorder() {
        if borderWidth.isNaN || borderWidth <= 0 || borderColor == nil {
            return
        }
        clipsToBounds = true
        layer.borderColor = borderColor!.cgColor
        layer.borderWidth = scaledValue(borderWidth)
    }
    
    private func scaledValue(_ value: CGFloat) -> CGFloat {
        return value / UIScreen.main.scale
    }
}
