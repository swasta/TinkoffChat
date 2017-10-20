//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var dataSource = ConversationsListDataSource(communicationManager)
    private lazy var communicationManager: CommunicationManager = {
        let communicationManager = CommunicationManager(with: MultipeerCommunicator(with: MessageSerializer()))
        communicationManager.delegate = self
        return communicationManager
    }()
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.updateConversationList()
        }
        communicationManager.delegate = self
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conversationViewController = segue.destination as? ConversationViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            let selectedConversation = dataSource.conversation(for: selectedIndexPath)
            conversationViewController.communicationManager = communicationManager
            conversationViewController.conversation = selectedConversation
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    @IBAction func unwindToConversationsList(sender: UIStoryboardSegue) {
        
    }
    
    // MARK: Private methods
    
    private func updateConversationList() {
        dataSource.update()
        self.tableView.reloadData()
    }
}

extension ConversationsListViewController: CommunicationManagerDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.updateConversationList()
        }
    }
}
