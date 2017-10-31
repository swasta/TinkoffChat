//
//  ProfileOperationQueueStorage.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

/*
 Although GCD and OperationQueue storage interfaces have exactly the same methods, I intentionally created them separately. This makes it obvious, that storage service has two different type of storages.
*/
protocol IProfileOperationQueueStorage: class {
    func save(_ profile: ProfileStorageModel, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void)
    func load(completionHandler: @escaping (ProfileStorageModel?, Error?) -> Void)
}

class ProfileOperationQueueStorage: IProfileOperationQueueStorage {
    private let queue = OperationQueue()
    private let profileHandler: IProfileHandler
    
    init(_ profileHandler: IProfileHandler) {
        self.profileHandler = profileHandler
    }
    
    func save(_ profile: ProfileStorageModel, completionHandler: @escaping (Bool, Error?) -> Void) {
        let saveOperation = SaveProfileOperation(profile, profileHandler, completionHandler: completionHandler)
        queue.addOperation(saveOperation)
    }
    
    func load(completionHandler: @escaping (ProfileStorageModel?, Error?) -> Void) {
        let loadOperation = LoadProfileOperation(profileHandler, completionHandler: completionHandler)
        queue.addOperation(loadOperation)
    }
}
