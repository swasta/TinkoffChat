//
//  AnyParser.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 16/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class AnyParser<Model> {
    func parse(data: Data) -> Model? {
        fatalError("This class should be subclassed")
    }
}

