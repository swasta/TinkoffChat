//
//  IRequestSender.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 16/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

struct RequestConfig<Model> {
    let request: IRequest
    let parser: AnyParser<Model>
}

enum Result<T> {
    case success(T)
    case error(String)
}

protocol IRequestSender: class {
    func send<Model>(config: RequestConfig<Model>, completionHandler: @escaping (Result<Model>) -> Void)
}
