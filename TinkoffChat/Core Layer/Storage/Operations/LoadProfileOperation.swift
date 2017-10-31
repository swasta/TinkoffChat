//
//  LoadProfileOperation.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 15/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class LoadProfileOperation: Operation {
    private let completionHandler: (ProfileStorageModel?, Error?) -> Void
    private let profileHandler: IProfileHandler
    
    init(_ profileHandler: IProfileHandler, completionHandler: @escaping (ProfileStorageModel?, Error?) -> Void) {
        self.profileHandler = profileHandler
        self.completionHandler = completionHandler
    }
    
    override func main() {
        if isCancelled {
            return
        }
        do {
            let profile = try profileHandler.load()
            completionHandler(profile, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
}
