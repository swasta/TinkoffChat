//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IStorageManager: class {
    func loadProfile(completionHandler: @escaping (ProfileStorageModel) -> Void)
    func save(profileStorageModel: ProfileStorageModel, completionHandler: @escaping () -> Void)
}

class StorageManager: IStorageManager {
    let coreDataStack: ICoreDataStack
    
    init(_ coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func loadProfile(completionHandler: @escaping (ProfileStorageModel) -> Void) {
        let masterContext = coreDataStack.masterContext
        let mainContext = coreDataStack.mainContext
        masterContext.perform {
            let appUser = AppUser.findOrInsertAppUser(in: masterContext)
            guard let currentUser = appUser.currentUser else {
                assertionFailure("Failed to find or create a current user")
                return
            }
            let currentUserObjectID = currentUser.objectID
            mainContext.perform {
                guard let currentUser = mainContext.object(with: currentUserObjectID) as? User else {
                    assertionFailure("Failed to get current user from master contexr")
                    return
                }
                var profileImage: UIImage?
                if let imageData = currentUser.profileImage {
                    profileImage = UIImage(data: imageData)
                }
                let profile = ProfileStorageModel(name: currentUser.name, userInfo: currentUser.info, profileImage: profileImage)
                completionHandler(profile)
            }
        }
    }
    
    func save(profileStorageModel: ProfileStorageModel, completionHandler: @escaping () -> Void) {
        let masterContext = coreDataStack.masterContext
        masterContext.perform {
            let appUser = AppUser.findOrInsertAppUser(in: masterContext)
            guard let currentUser = appUser.currentUser else {
                assertionFailure("Failed to find or create a current user")
                return
            }
            currentUser.name = profileStorageModel.name
            currentUser.info = profileStorageModel.userInfo
            if let profileImage = profileStorageModel.profileImage {
                currentUser.profileImage = UIImageJPEGRepresentation(profileImage, 1.0)
            }
          self.coreDataStack.performSave(in: masterContext, completionHandler: completionHandler)
        }
    }
}
