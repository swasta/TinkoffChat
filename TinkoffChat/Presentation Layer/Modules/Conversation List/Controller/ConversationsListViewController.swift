//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    private enum SegueIdentifiers {
        static let profileSegue = "ProfileSegue"
        static let conversationSegue = "ConversationSegue"
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var rootAssembly: IRootAssembly!
    private var model: IConversationsListModel!
    
    // MARK: Dependency injection
    
    func setDependencies(_ rootAssembly: IRootAssembly,
                         _ model: IConversationsListModel) {
        self.rootAssembly = rootAssembly
        self.model = model
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        model.configureWith(tableView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        rootAssembly.profileAssembly.assembly(profileViewController)
    }
    
    private func handleConversationSegue(with destination: UIViewController) {
        guard let conversationViewController = destination as? ConversationViewController else {
            return
        }
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            assertionFailure("Unknown segue destination view controller")
            return
        }
        let selectedConversationID = model.getConversationID(for: selectedIndexPath)
        rootAssembly.conversationAssembly.assembly(conversationViewController,
                                                   conversationID: selectedConversationID)
        tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
    
    @IBAction func unwindToConversationsList(sender: UIStoryboardSegue) { }
    
    // MARK: Private methods
    
    private func assertDependencies() {
        assert(model != nil)
    }
}
