//
//  CommunicationService.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 19/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class CommunicationService: ICommunicationService {
    weak var delegate: ICommunicationServiceDelegate?
    
    let communicator: ICommunicator
    
    init(_ communicator: ICommunicator) {
        self.communicator = communicator
    }
    
    // MARK: - API
    
    func sendMessage(text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?) {
        communicator.sendMessage(text: text, to: userID, completionHandler: completionHandler)
    }
}

// MARK: - ICommunicationServiceDelegate

extension CommunicationService: ICommunicatorDelegate {
    func didFindUser(userID: String, userName: String?) {
        delegate?.didFindUser(userID: userID, userName: userName)
    }
    
    func didLoseUser(userID: String) {
        delegate?.didLoseUser(userID: userID)
    }
    
    func didReceiveMessage(text: String, fromUser sender: String, toUser receiver: String) {
        delegate?.didReceiveMessage(text: text, fromUser: sender, toUser: receiver)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        fatalError("\(error)")
    }
    
    func failedToStartAdvertising(error: Error) {
        fatalError("\(error)")
    }
}
