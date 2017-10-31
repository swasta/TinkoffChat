//
//  FileBasedProfileHandler.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 30/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

protocol IProfileHandler: class {
    func save(_ profile: ProfileStorageModel) throws
    func load() throws -> ProfileStorageModel?
}

class FileBasedProfileHandler: IProfileHandler {
    enum FileBasedProfileSaverError: Error {
        case corruptedData
    }
    private static let profileImageKey = "avatarKey"
    private static let nameKey = "nameKey"
    private static let userInfoKey = "userInfoKey"
    private static let fileName = "profileData"
    
    private let fileManager = FileManager.default
    
    private var filePath: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(FileBasedProfileHandler.fileName)
    }
    
    func save(_ profile: ProfileStorageModel) throws {
        let dataDictionary = serialize(profile)
        let data = NSKeyedArchiver.archivedData(withRootObject: dataDictionary)
        try data.write(to: filePath)
    }
    
    func load() throws -> ProfileStorageModel? {
        guard fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        let data = try Data(contentsOf: filePath)
        let profile = try deserializeProfile(from: data)
        return profile
    }
    
    private func serialize(_ profile: ProfileStorageModel) -> [String: Any] {
        let profileImageData = NSKeyedArchiver.archivedData(withRootObject: profile.profileImage)
        return [FileBasedProfileHandler.profileImageKey: profileImageData,
                FileBasedProfileHandler.nameKey: profile.name,
                FileBasedProfileHandler.userInfoKey: profile.userInfo]
    }
    
    private func deserializeProfile(from data: Data) throws -> ProfileStorageModel? {
        guard let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any],
            let name = dictionary[FileBasedProfileHandler.nameKey] as? String,
            let userInfo = dictionary[FileBasedProfileHandler.userInfoKey] as? String,
            let profileImageData = dictionary[FileBasedProfileHandler.profileImageKey] as? Data,
            let profileImage = NSKeyedUnarchiver.unarchiveObject(with: profileImageData) as? UIImage
            else {
                throw FileBasedProfileSaverError.corruptedData
        }
        return ProfileStorageModel(name: name, userInfo: userInfo, profileImage: profileImage)
    }
}
