//
//  LoadImageRequest.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 18/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class LoadImageRequest: IRequest {
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
}
