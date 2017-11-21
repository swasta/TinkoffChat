//
//  PixabayAPIRequest.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 17/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol PixabayAPIRequest: IRequest {
    typealias QueryParameters = [String: String]
    
    var apiKey: String { get }
    var urlRequest: URLRequest { get }
    var queryParameters: QueryParameters { get }
}

extension PixabayAPIRequest {
    var apiKey: String {
        return "4806904-82a09b61082fc371e1a778266"
    }
    
    var baseURL: String {
        return "https://pixabay.com/api?"
    }
    
    var urlRequest: URLRequest {
        let queryString = prepareQueryStringFrom(queryParameters)
        let urlString = baseURL + queryString
        guard let url = URL(string: urlString) else {
            preconditionFailure("\(urlString) couldn't be parsed to URL")
        }
        return URLRequest(url: url)
    }
    
    private func prepareQueryStringFrom(_ queryParameters: QueryParameters) -> String {
        return queryParameters.flatMap({ "\($0.key)=\($0.value)" }).joined(separator: "&")
    }
}
