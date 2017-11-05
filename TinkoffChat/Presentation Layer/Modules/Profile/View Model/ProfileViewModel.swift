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
    
    init(name: String?, userInfo: String?, profileImage: UIImage?) {
        self.name = name ?? ""
        self.userInfo = userInfo ?? ""
        self.profileImage = profileImage ?? #imageLiteral(resourceName: "placeholder-user")
    }
    
    init() {
        self.init(name: nil, userInfo: nil, profileImage: nil)
    }
    
    func createCopyWithChanged(name: String? = nil, userInfo: String? = nil, profileImage: UIImage? = nil) -> ProfileViewModel {
        let copyName = name ?? self.name
        let copyUserInfo = userInfo ?? self.userInfo
        let copyProfileImage = profileImage ?? self.profileImage
        return ProfileViewModel(name: copyName, userInfo: copyUserInfo, profileImage: copyProfileImage)
    }
}

extension ProfileViewModel: Equatable {
    static func == (lhs: ProfileViewModel, rhs: ProfileViewModel) -> Bool {
        return lhs.name == rhs.name &&
            lhs.userInfo == rhs.userInfo &&
            lhs.profileImage == rhs.profileImage
    }
}
