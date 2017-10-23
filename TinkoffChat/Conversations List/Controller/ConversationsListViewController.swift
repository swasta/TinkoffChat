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
    
    private let tableDelegate = ConversationsListTableDelegate()
    private lazy var tableDataSource = ConversationsListTableDataSource(communicationManager)
    private lazy var communicationManager: CommunicationManager = {
        let communicationManager = CommunicationManager(with: MultipeerCommunicator(with: MessageSerializer()))
        communicationManager.delegate = self
        communicationManager.enableCommunicationServices(true)
        return communicationManager
    }()
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        communicationManager.delegate = self
        updateConversationList()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conversationViewController = segue.destination as? ConversationViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            let selectedConversation = tableDataSource.conversation(for: selectedIndexPath)
            conversationViewController.communicationManager = communicationManager
            conversationViewController.conversation = selectedConversation
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    @IBAction func unwindToConversationsList(sender: UIStoryboardSegue) { }
    
    // MARK: Private methods
    
    private func updateConversationList() {
        tableDataSource.update()
        tableView.reloadData()
    }
}

extension ConversationsListViewController: CommunicationManagerDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.updateConversationList()
        }
    }
}
