//
//  ICommunicationService.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol ICommunicationService: class {
    weak var delegate: ICommunicationServiceDelegate? { get set }
    var communicator: ICommunicator { get }
    func sendMessage(text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
}

protocol ICommunicationServiceDelegate: class {
    func didFindUser(userID: String, userName: String?)
    func didLoseUser(userID: String)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

// Optional methods
extension ICommunicationServiceDelegate {
    func didFindUser(userID: String, userName: String?) { }
}
