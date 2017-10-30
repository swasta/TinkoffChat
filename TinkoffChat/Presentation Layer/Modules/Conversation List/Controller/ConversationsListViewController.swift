//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    private struct SegueIdentifiers {
        static let profileSegue = "ProfileSegue"
        static let conversationSegue = "ConversationSegue"
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    var tableDelegate: UITableViewDelegate!
    var tableDataSource: IConversationsListTableDataSource!
    var model: IConversationsListModel!
    
    // MARK: Dependency injection
    
    func setDependencies(_ tableDataSource: IConversationsListTableDataSource, _ tableDelegate: UITableViewDelegate, _ model: IConversationsListModel) {
        self.tableDataSource = tableDataSource
        self.tableDelegate = tableDelegate
        self.model = model
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        model.resumeListeningToCommunicationService()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case SegueIdentifiers.profileSegue?:
            handleProfileSegue(with: segue.destination)
        case SegueIdentifiers.conversationSegue?:
            handleConversationSegue(with: segue.destination)
        default:
            assertionFailure("Unknown segue identifier")
        }
    }
    
    private func handleProfileSegue(with destination: UIViewController) {
        guard
            let containerViewController = destination as? UINavigationController,
            let profileViewController = containerViewController.topViewController as? ProfileViewController else {
                assertionFailure("Unknown segue destination view controller")
                return
        }
        RootAssembly.profileAssembly.assembly(profileViewController)
    }
    
    private func handleConversationSegue(with destination: UIViewController) {
        guard let conversationViewController = destination as? ConversationViewController else {
            return
        }
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            assertionFailure("Unknown segue destination view controller")
            return
        }
        let selectedConversation = tableDataSource.conversation(for: selectedIndexPath)
        RootAssembly.conversationAssembly.assembly(conversationViewController,
                                                   conversation: selectedConversation)
        tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
    
    @IBAction func unwindToConversationsList(sender: UIStoryboardSegue) { }
    
    // MARK: Private methods
    
    private func assertDependencies() {
        assert(tableDataSource != nil && tableDelegate != nil && model != nil)
    }
}

extension ConversationsListViewController: IConversationsListModelDelegate {
    func setup(dataSource: [ConversationViewModel]) {
        tableDataSource.setup(dataSource: dataSource)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
