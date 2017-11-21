//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 14/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IProfileModel: class {
    func saveProfile(completionHandler: @escaping () -> Void)
    func loadProfile(completionHandler: @escaping (ProfileViewModel) -> Void)
    func update(with profile: ProfileViewModel)
    var profileWasModified: Bool { get }
}

class ProfileModel: IProfileModel {
    private var originalProfile: ProfileViewModel = ProfileViewModel()
    private var modifiedProfile: ProfileViewModel = ProfileViewModel()
    
    private let profileStorageService: IProfileStorageService
    
    init(_ profileStorageService: IProfileStorageService) {
        self.profileStorageService = profileStorageService
    }
    
    func loadProfile(completionHandler: @escaping (ProfileViewModel) -> Void) {
        profileStorageService.loadProfile { loadedProfile in
            let profileViewModel = ProfileViewModel(name: loadedProfile.name, userInfo: loadedProfile.userInfo, profileImage: loadedProfile.profileImage)
            self.originalProfile = profileViewModel
            self.modifiedProfile = profileViewModel
            completionHandler(profileViewModel)
        }
    }
    
    func saveProfile(completionHandler: @escaping () -> Void) {
        let profileToStore = ProfileStorageModel(name: modifiedProfile.name,
                                                 userInfo: modifiedProfile.userInfo,
                                                 profileImage: modifiedProfile.profileImage)
        profileStorageService.save(profileStorageModel: profileToStore) { [unowned self] in
            self.originalProfile = self.modifiedProfile
            completionHandler()
        }
    }
    
    func update(with profile: ProfileViewModel) {
        self.modifiedProfile = profile
    }
    
    var profileWasModified: Bool {
        return modifiedProfile != originalProfile
    }
}
