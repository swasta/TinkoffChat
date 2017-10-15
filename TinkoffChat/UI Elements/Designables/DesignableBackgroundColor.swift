//
//  DesignableBackgroundColor.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol DesignableBackgroundColor {
    var disabledAdjustsBackgroundColor: Bool { get set }
    var normalBackgroundColor: UIColor? { get set }
    var disabledBackgroundColor: UIColor? { get set }
}

extension DesignableBackgroundColor where Self: UIButton {
    func setupBackgroundColor() {
        if disabledAdjustsBackgroundColor {
            backgroundColor = isEnabled ? normalBackgroundColor : disabledBackgroundColor
        }
    }
}
