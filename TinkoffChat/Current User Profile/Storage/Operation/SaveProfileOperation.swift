//
//  SaveProfileOperation.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class SaveProfileOperation: Operation {
    private let userProfile: UserProfile
    private let completion: (Bool, Error?) -> Void
    private let dataStorage: FileBasedStorage
    
    init(with userProfile: UserProfile, dataStorage: FileBasedStorage, completion: @escaping (Bool, Error?) -> Void) {
        self.userProfile = userProfile
        self.dataStorage = dataStorage
        self.completion = completion
    }
    
    override func main() {
        if isCancelled {
            return
        }
        do {
            try dataStorage.save(userProfile)
            DispatchQueue.main.async {
                self.completion(true, nil)
            }
        } catch {
            self.completion(false, error)
        }
    }
}
