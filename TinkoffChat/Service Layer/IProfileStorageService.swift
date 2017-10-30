//
//  IProfileStorageService.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IProfileStorageService: class {
    func saveWithGCD(profileStorageModel: ProfileStorageModel, completionHandler: @escaping (Bool, Error?) -> ())
    func loadWithGCD(completionHandler: @escaping (ProfileStorageModel?, Error?) ->())
    func saveWithOperationQueue(profileStorageModel: ProfileStorageModel, completionHandler: @escaping (Bool, Error?) -> ())
    func loadWithOperationQueue(completionHandler: @escaping (ProfileStorageModel?, Error?) ->())
}
