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
    
    private let dataSource = ConversationsListDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Interactive animated deselection of a cell
        if let indexPath = tableView.indexPathForSelectedRow, let transitionCoordinator = transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (context) in
                self.tableView.deselectRow(at: indexPath, animated: animated)
            }, completion: { (context) in
                if context.isCancelled {
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            })
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let conversationViewController = segue.destination as? ConversationViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let selectedCell = dataSource.tableView(tableView, cellForRowAt: selectedIndexPath) as? ConversationTableViewCell {
            let selectedConversation = dataSource.conversation(for: selectedIndexPath)
            let conversationDataSource = ConversationsDataSource(conversation: selectedConversation)
            conversationViewController.dataSource = conversationDataSource
            conversationViewController.navigationItem.title = selectedCell.name
        }
    }
    
    @IBAction func unwindToConversationsList(sender: UIStoryboardSegue) {
        
    }
}
