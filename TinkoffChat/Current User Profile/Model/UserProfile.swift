//
//  UserProfile.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 14/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

struct UserProfile {
    let name: String
    let userInfo: String
    let profileImage: UIImage
    
    static func createDefaultProfile() -> UserProfile {
        let name = "John Doe"
        let userInfo = "Lorem ipsum dolor sit er elit lamet"
        return UserProfile(name: name, userInfo: userInfo, profileImage: #imageLiteral(resourceName: "placeholder-user"))
    }
    
    func createCopyWithChanged(name: String? = nil, userInfo: String? = nil, profileImage: UIImage? = nil) -> UserProfile {
        let copyName = name ?? self.name
        let copyUserInfo = userInfo ?? self.userInfo
        let copyProfileImage = profileImage ?? self.profileImage
        return UserProfile(name: copyName, userInfo: copyUserInfo, profileImage: copyProfileImage)
    }
}

extension UserProfile: Equatable {
    static func ==(lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.name == rhs.name &&
            lhs.userInfo == rhs.userInfo &&
            lhs.profileImage == rhs.profileImage
    }
}
