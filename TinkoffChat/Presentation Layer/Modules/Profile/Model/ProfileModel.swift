//
//  UserProfile.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 14/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IProfileModel: class {
    func saveProfileWithGCD(completionHandler: @escaping (Bool, Error?) -> ())
    func loadProfile(completionHandler: @escaping (ProfileViewModel?, Error?) -> ())
    func saveProfileWithOperationQueue(completionHandler: @escaping (Bool, Error?) -> ())
    func update(with profile: ProfileViewModel)
    var profileWasModified: Bool { get }
}

class ProfileModel: IProfileModel {
    private var originalProfile: ProfileViewModel = ProfileViewModel.createDefaultProfile()
    private var modifiedProfile: ProfileViewModel = ProfileViewModel.createDefaultProfile()
    
    private let profileStorageService: IProfileStorageService
    
    init(_ profileStorageService: IProfileStorageService) {
        self.profileStorageService = profileStorageService
    }
    
    func loadProfile(completionHandler: @escaping (ProfileViewModel?, Error?) -> ()) {
        let randomCondition = arc4random_uniform(2) == 0
        if randomCondition == true {
            loadProfileWithGCD(completionHandler: completionHandler)
        } else {
            loadProfileWithOperationQueue(completionHandler: completionHandler)
        }
    }
    
    private func loadProfileWithGCD(completionHandler: @escaping (ProfileViewModel?, Error?) -> ()) {
        profileStorageService.loadWithGCD { [unowned self] (profile, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            if let loadedProfile = profile {
                let profileViewModel = ProfileViewModel(name: loadedProfile.name,
                                                        userInfo: loadedProfile.userInfo,
                                                        profileImage: loadedProfile.profileImage)
                self.originalProfile = profileViewModel
                self.modifiedProfile = profileViewModel
                completionHandler(profileViewModel, nil)
            } else {
                completionHandler(nil, nil)
            }
        }
    }
    
    private func loadProfileWithOperationQueue(completionHandler: @escaping (ProfileViewModel?, Error?) -> ()) {
        profileStorageService.loadWithOperationQueue { [unowned self] (profile, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            if let loadedProfile = profile {
                let profileViewModel = ProfileViewModel(name: loadedProfile.name,
                                                        userInfo: loadedProfile.userInfo,
                                                        profileImage: loadedProfile.profileImage)
                self.originalProfile = profileViewModel
                self.modifiedProfile = profileViewModel
                completionHandler(profileViewModel, nil)
            } else {
                completionHandler(nil, nil)
            }
        }
    }
    
    func saveProfileWithGCD(completionHandler: @escaping (Bool, Error?) -> ()) {
        let profileToStore = ProfileStorageModel(name: modifiedProfile.name,
                                                 userInfo: modifiedProfile.userInfo,
                                                 profileImage: modifiedProfile.profileImage)
        profileStorageService.saveWithGCD(profileStorageModel: profileToStore) { [unowned self] (success, error) in
            if success {
                self.originalProfile = self.modifiedProfile
            }
            completionHandler(success, error)
        }
    }
    
    func saveProfileWithOperationQueue(completionHandler: @escaping (Bool, Error?) -> ()) {
        let profileToStore = ProfileStorageModel(name: modifiedProfile.name,
                                                 userInfo: modifiedProfile.userInfo,
                                                 profileImage: modifiedProfile.profileImage)
        profileStorageService.saveWithOperationQueue(profileStorageModel: profileToStore) { [unowned self] (success, error) in
            if success {
                self.originalProfile = self.modifiedProfile
            }
            completionHandler(success, error)
        }
    }
    
    func update(with profile: ProfileViewModel) {
        self.modifiedProfile = profile
    }
    
    var profileWasModified: Bool {
        return modifiedProfile != originalProfile
    }
}
