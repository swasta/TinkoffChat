//
//  LoadProfileOperation.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class LoadProfileOperation: Operation {
    private let completion: (UserProfile?, Error?) -> Void
    private let dataStorage: FileBasedStorage
    
    init(with dataStorage: FileBasedStorage, completion: @escaping (UserProfile?, Error?) -> Void) {
        self.dataStorage = dataStorage
        self.completion = completion
    }
    
    override func main() {
        if isCancelled {
            return
        }
        do {
            let profile = try dataStorage.loadUserProfile()
            DispatchQueue.main.async {
                self.completion(profile, nil)
            }
        } catch {
            DispatchQueue.main.async {
                self.completion(nil, error)
            }
        }
    }
}
