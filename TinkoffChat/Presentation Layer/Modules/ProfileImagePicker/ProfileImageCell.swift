//
//  ProfileImageCell.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 18/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ProfileImageCell: UICollectionViewCell {
    class var identifier: String {
        return String(describing: self)
    }
    
    var hasLoadedImage = false
    
    var image: UIImage? {
        didSet {
            profileImageView.image = image
        }
    }
    
    var indexPath: IndexPath?
    
    @IBOutlet private weak var profileImageView: UIImageView!
}
