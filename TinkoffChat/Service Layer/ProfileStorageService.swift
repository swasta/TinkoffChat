//
//  ProfileStorageService.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IProfileStorageService: class {
    func save(profileStorageModel: ProfileStorageModel, completionHandler: @escaping () -> Void)
    func loadProfile(completionHandler: @escaping (ProfileStorageModel) -> Void)
}

class ProfileStorageService: IProfileStorageService {
    private let storageManager: IStorageManager
    
    init(_ storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    // MARK: - API
    
    func loadProfile(completionHandler: @escaping (ProfileStorageModel) -> Void) {
        storageManager.loadProfile(completionHandler: completionHandler)
    }
    
    func save(profileStorageModel: ProfileStorageModel, completionHandler: @escaping () -> Void) {
        storageManager.save(profileStorageModel: profileStorageModel, completionHandler: completionHandler)
    }
}
