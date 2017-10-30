//
//  ProfileViewModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

struct ProfileViewModel {
    let name: String
    let userInfo: String
    let profileImage: UIImage
    
    static func createDefaultProfile() -> ProfileViewModel {
        let name = "John Doe"
        let userInfo = "Lorem ipsum dolor sit er elit lamet"
        return ProfileViewModel(name: name, userInfo: userInfo, profileImage: #imageLiteral(resourceName: "placeholder-user"))
    }
    
    func createCopyWithChanged(name: String? = nil, userInfo: String? = nil, profileImage: UIImage? = nil) -> ProfileViewModel {
        let copyName = name ?? self.name
        let copyUserInfo = userInfo ?? self.userInfo
        let copyProfileImage = profileImage ?? self.profileImage
        return ProfileViewModel(name: copyName, userInfo: copyUserInfo, profileImage: copyProfileImage)
    }
}

extension ProfileViewModel: Equatable {
    static func ==(lhs: ProfileViewModel, rhs: ProfileViewModel) -> Bool {
        return lhs.name == rhs.name &&
            lhs.userInfo == rhs.userInfo &&
            lhs.profileImage == rhs.profileImage
    }
}
