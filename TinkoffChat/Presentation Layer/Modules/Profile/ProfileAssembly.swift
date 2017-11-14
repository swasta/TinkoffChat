//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class ProfileAssembly {
    
    private let storageManager: IStorageManager
    
    init(_ storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    func assembly(_ profileViewController: ProfileViewController) {
        profileViewController.model = getProfileModel()
    }
    
    private func getProfileModel() -> IProfileModel {
        let profileStorageService = getProfileStorageService()
        return ProfileModel(profileStorageService)
    }
    
    private func getProfileStorageService() -> IProfileStorageService {
        return ProfileStorageService(storageManager)
    }
}
