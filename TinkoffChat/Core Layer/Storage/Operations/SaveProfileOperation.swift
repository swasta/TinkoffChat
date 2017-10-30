//
//  SaveProfileOperation.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class SaveProfileOperation: Operation {
    private let userProfile: ProfileStorageModel
    private let completionHandler: (Bool, Error?) -> ()
    private let profileHandler: IProfileHandler
    
    init(with userProfile: ProfileStorageModel, profileHandler: IProfileHandler, completionHandler: @escaping (Bool, Error?) -> Void) {
        self.userProfile = userProfile
        self.profileHandler = profileHandler
        self.completionHandler = completionHandler
    }
    
    override func main() {
        if isCancelled {
            return
        }
        do {
            try profileHandler.save(userProfile)
            completionHandler(true, nil)
        } catch {
            completionHandler(false, error)
        }
    }
}
