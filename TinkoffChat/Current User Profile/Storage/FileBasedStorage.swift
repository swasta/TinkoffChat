//
//  FileBasedStorage.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class FileBasedStorage {
    private static let profileImageKey = "avatarKey"
    private static let nameKey = "nameKey"
    private static let userInfoKey = "userInfoKey"
    private static let fileName = "profileData"
    
    private let fileManager = FileManager.default
    
    private var filePath: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(FileBasedStorage.fileName)
    }
    
    // MARK: API
    
    enum FileBasedStorageError: Error {
        case corruptedData
    }
    
    func save(_ profile: UserProfile) throws {
        let dataDitionary = serialize(profile)
        let data = NSKeyedArchiver.archivedData(withRootObject: dataDitionary)
        try data.write(to: filePath)
    }
    
    func loadUserProfile() throws -> UserProfile? {
        guard fileManager.fileExists(atPath: filePath.path) else {
            throw FileBasedStorageError.corruptedData
        }
        let data = try Data(contentsOf: filePath)
        let profile = try deserializeUserProfile(from: data)
        return profile
    }
    
    // MARK: Private methods
    
    private func serialize(_ profile: UserProfile) -> [String: Any] {
        let profileImageData = NSKeyedArchiver.archivedData(withRootObject: profile.profileImage)
        return [FileBasedStorage.profileImageKey: profileImageData,
                FileBasedStorage.nameKey: profile.name,
                FileBasedStorage.userInfoKey: profile.userInfo]
    }
    
    private func deserializeUserProfile(from data: Data) throws -> UserProfile? {
        guard let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : Any],
            let name = dictionary[FileBasedStorage.nameKey] as? String,
            let userInfo = dictionary[FileBasedStorage.userInfoKey] as? String,
            let profileImage = NSKeyedUnarchiver.unarchiveObject(with: dictionary[FileBasedStorage.profileImageKey] as! Data) as? UIImage
            else {
                throw FileBasedStorageError.corruptedData
        }
        return UserProfile(name: name, userInfo: userInfo, profileImage: profileImage)
    }
}
