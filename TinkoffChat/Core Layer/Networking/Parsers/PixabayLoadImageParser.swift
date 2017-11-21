//
//  PixabayLoadImageParser.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 18/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

struct PixabayImageAPIModel {
    let image: UIImage
}

class PixabayLoadImageParser: AnyParser<PixabayImageAPIModel> {
    override func parse(data: Data) -> PixabayImageAPIModel? {
        if let image = UIImage(data: data) {
            return PixabayImageAPIModel(image: image)
        } else {
            return nil
        }
    }
}
