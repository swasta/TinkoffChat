//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class OperationDataManager: ProfileDataManager {
    private let queue = OperationQueue()
    private let dataStorage = FileBasedStorage()
    
    func save(_ profile: UserProfile, completion: @escaping (Bool, Error?) -> Void) {
        let saveOperation = SaveProfileOperation(with: profile, dataStorage: dataStorage, completion: completion)
        queue.addOperation(saveOperation)
    }
    
    func loadUserProfile(completion: @escaping (UserProfile?, Error?) -> Void) {
        let loadOperation = LoadProfileOperation(with: dataStorage, completion: completion)
        queue.addOperation(loadOperation)
    }
}
