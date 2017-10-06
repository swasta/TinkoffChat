//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    var conversation: Conversation! // cannot be nil, otherwise app must crash
    var dataManager: DataManager!
    private lazy var dataSource = ConversationDataSource(conversation: conversation)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        conversation.hasUnreadMessages = false
        dataManager.update(conversation)
    }
}
