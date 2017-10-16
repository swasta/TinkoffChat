//
//  ProfileDataManager.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol ProfileDataManager {
    func save(_ profile: UserProfile, completion: @escaping (Bool, Error?) -> Void)
    func loadUserProfile(completion: @escaping (UserProfile?, Error?) -> Void)
}
