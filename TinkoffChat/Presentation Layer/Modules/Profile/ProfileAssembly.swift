//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class ProfileAssembly {
    func assembly(_ profileViewController: ProfileViewController) {
        profileViewController.model = getProfileModel()
    }
    
    private func getProfileModel() -> IProfileModel {
        let profileStorageService = getProfileStorageService()
        return ProfileModel(profileStorageService)
    }
    
    private func getProfileStorageService() -> IProfileStorageService {
        let storages = getStorages()
        return ProfileStorageService(storages.profileGCDStorage, storages.profileOperationQueueStorage)
    }
    
    private func getStorages() -> (profileGCDStorage: IProfileGCDStorage, profileOperationQueueStorage: IProfileOperationQueueStorage) {
        let profileHandler = getProfileHandler()
        return (ProfileGCDStorage(profileHandler), ProfileOperationQueueStorage(profileHandler))
    }
    
    private func getProfileHandler() -> IProfileHandler {
        return FileBasedProfileHandler()
    }
}
