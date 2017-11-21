//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 17/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class RequestSender: IRequestSender {
    private let session = URLSession.shared
    
    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void) {
        let urlRequest = config.request.urlRequest
        session.dataTask(with: urlRequest) { (data, _, error) in
            switch error {
            case .some(let error):
                completionHandler(Result.error(error.localizedDescription))
            case .none:
                guard let data = data, let parsedModel = config.parser.parse(data: data) else {
                    completionHandler(Result.error("Received data couldn't be parsed"))
                    return
                }
                completionHandler(Result.success(parsedModel))
            }
        }.resume()
    }
}
