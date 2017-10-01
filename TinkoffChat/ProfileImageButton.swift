//
//  ProfileImageButton.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 01/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ProfileImageButton: DesignableButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        setupImageEdgeInsets()
    }
    
    private func setupImageEdgeInsets() {
        let imageEdgeInset = bounds.height / 5
        imageEdgeInsets = UIEdgeInsets(top: imageEdgeInset, left: imageEdgeInset, bottom: imageEdgeInset, right: imageEdgeInset)
    }
}
