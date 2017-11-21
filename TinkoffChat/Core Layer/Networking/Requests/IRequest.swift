//
//  IRequest.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 16/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IRequest: class {
    var urlRequest: URLRequest { get }
}
