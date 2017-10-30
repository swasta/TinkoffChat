//
//  ProfileStorageService.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class ProfileStorageService: IProfileStorageService {
    
    private let profileGCDStorage: IProfileGCDStorage
    private let profileOperationQueueStorage: IProfileOperationQueueStorage
    
    init(_ profileGCDStorage: IProfileGCDStorage, _ profileOperationQueueStorage: IProfileOperationQueueStorage) {
        self.profileGCDStorage = profileGCDStorage
        self.profileOperationQueueStorage = profileOperationQueueStorage
    }
    
    func saveWithGCD(profileStorageModel: ProfileStorageModel, completionHandler: @escaping (Bool, Error?) -> ()) {
        profileGCDStorage.save(profileStorageModel, completionHandler: completionHandler)
    }
    
    func loadWithGCD(completionHandler: @escaping (ProfileStorageModel?, Error?) -> ()) {
        profileGCDStorage.load(completionHandler: completionHandler)
    }
    
    func saveWithOperationQueue(profileStorageModel: ProfileStorageModel, completionHandler: @escaping (Bool, Error?) -> ()) {
        profileOperationQueueStorage.save(profileStorageModel, completionHandler: completionHandler)
    }
    
    func loadWithOperationQueue(completionHandler: @escaping (ProfileStorageModel?, Error?) -> ()) {
        profileOperationQueueStorage.load(completionHandler: completionHandler)
    }
}
