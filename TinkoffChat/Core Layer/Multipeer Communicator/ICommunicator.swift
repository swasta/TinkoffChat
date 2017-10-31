//
//  ICommunicator.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 19/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import MultipeerConnectivity

protocol ICommunicator: class {
    func sendMessage(text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    weak var delegate: ICommunicatorDelegate? { get set }
}

protocol ICommunicatorDelegate: class {
    // discovering
    func didFindUser(userID: String, userName: String?)
    func didLoseUser(userID: String)
    
    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    // messages
    func didReceiveMessage(text: String, fromUser sender: String, toUser receiver: String)
}
