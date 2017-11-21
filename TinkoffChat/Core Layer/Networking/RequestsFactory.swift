//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 17/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

struct RequestsFactory {
    struct PixabayAPIRequests {
        static func imageList() -> RequestConfig<[PixabayImageListAPIModel]> {
            return RequestConfig<[PixabayImageListAPIModel]>(request: PixabayImageListRequest(), parser: PixabayImageListParser())
        }
    }
    struct CommonRequest {
        static func loadImage(from url: URL) -> RequestConfig<PixabayImageAPIModel> {
            return RequestConfig<PixabayImageAPIModel>(request: LoadImageRequest(url), parser: PixabayLoadImageParser())
        }
    }
}
