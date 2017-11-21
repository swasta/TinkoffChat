//
//  ProfileImagePickerAssembly.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 18/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class ProfileImagePickerAssembly {
    func assembly(_ profileImagePickerViewController: ProfileImagePickerViewController) {
        profileImagePickerViewController.model = getModel()
    }
    
    func getModel() -> IProfileImagePickerModel {
        return ProfileImagePickerModel(getImageLoaderService())
    }
    
    func getImageLoaderService() -> IProfileImageLoaderService {
        return ProfileImageLoaderService(getRequestSender())
    }
    
    func getRequestSender() -> IRequestSender {
        return RequestSender()
    }
}
