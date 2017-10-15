//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class GCDDataManager: ProfileDataManager {
    private let serialQueue = DispatchQueue(label: "com.nikitaborodulin.gcdDataManagerQueue")
    private let dataStorage = FileBasedStorage()
    
    func save(_ profile: UserProfile, completion: @escaping (Bool, Error?) -> Void) {
        serialQueue.async {
            do {
                try self.dataStorage.save(profile)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    func loadUserProfile(completion: @escaping (UserProfile?, Error?) -> Void) {
        serialQueue.async {
            do {
                let profile = try self.dataStorage.loadUserProfile()
                DispatchQueue.main.async {
                    completion(profile, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
