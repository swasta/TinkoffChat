//
//  PixabayImageListParser.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 17/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

private struct PixabayImageListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case images = "hits"
    }
    let images: [PixabayImageListAPIModel]
}

struct PixabayImageListAPIModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case url = "webformatURL"
    }
    let id: Int
    let url: String
}

class PixabayImageListParser: AnyParser<[PixabayImageListAPIModel]> {
    private let decoder = JSONDecoder()
    override func parse(data: Data) -> [PixabayImageListAPIModel]? {
        var response: PixabayImageListResponse
        do {
            response = try decoder.decode(PixabayImageListResponse.self, from: data)
        } catch {
            print("error trying to convert data to JSON")
            return nil
        }
        return response.images
    }
}
