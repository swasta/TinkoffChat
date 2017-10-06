//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dataManager = DataManager()
    private lazy var dataSource = ConversationsListDataSource(dataManager)
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conversationViewController = segue.destination as? ConversationViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let selectedCell = dataSource.tableView(tableView, cellForRowAt: selectedIndexPath) as? ConversationTableViewCell {
            self.selectedIndexPath = selectedIndexPath
            let selectedConversation = dataSource.conversation(for: selectedIndexPath)
            conversationViewController.conversation = selectedConversation
            conversationViewController.dataManager = dataManager
            conversationViewController.navigationItem.title = selectedCell.name
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    @IBAction func unwindToConversationsList(sender: UIStoryboardSegue) {
        
    }
}
