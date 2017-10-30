//
//  ProfileGCDStorage.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IProfileGCDStorage: class {
    func save(_ profile: ProfileStorageModel, completionHandler: @escaping (_ success: Bool, _ error: Error?) -> ())
    func load(completionHandler: @escaping (ProfileStorageModel?, Error?) ->())
}

class ProfileGCDStorage: IProfileGCDStorage {
    private let serialQueue = DispatchQueue(label: "com.nikitaborodulin.TinkoffChat.profileGCDStorageQueue")
    private let profileHandler: IProfileHandler
    
    init(_ profileHandler: IProfileHandler) {
        self.profileHandler = profileHandler
    }
    
    func save(_ profile: ProfileStorageModel, completionHandler: @escaping (Bool, Error?) -> ()) {
        serialQueue.async {
            do {
                try self.profileHandler.save(profile)
                completionHandler(true, nil)
            } catch {
                completionHandler(false, error)
            }
        }
    }
    
    func load(completionHandler: @escaping (ProfileStorageModel?, Error?) -> ()) {
        serialQueue.async {
            do {
                let profile = try self.profileHandler.load()
                completionHandler(profile, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
}
