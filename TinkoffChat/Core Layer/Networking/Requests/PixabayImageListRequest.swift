//
//  PixabayImageListRequest.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 17/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class PixabayImageListRequest: PixabayAPIRequest {
    var queryParameters: [String: String] {
        return ["key": apiKey,
                "imageType": "photo",
                "per_page": "100",
                "safeSearch": "true"
        ]
    }
}
