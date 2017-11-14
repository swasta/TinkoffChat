//
//  IdentifierGenerator.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 10/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IIdentifierGenerator: class {
    func generateIdentifier() -> String
}

class IdentifierGenerator: IIdentifierGenerator {
    func generateIdentifier() -> String {
        return ("\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString())!
    }
}
