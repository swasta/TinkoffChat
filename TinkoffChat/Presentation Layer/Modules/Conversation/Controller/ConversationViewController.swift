//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    var model: IConversationModel! // cannot be nil, otherwise app must crash
    
    var tableDataSource: IConversationTableDataSource!
    var tableDelegate: IConversationTableDelegate!
    
    private var sendMessageViewController: SendMessageViewController!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noMessagesView: UIView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Dependency injection
    
    func setDependencies(_ tableDataSource: IConversationTableDataSource, _ tableDelegate: IConversationTableDelegate, _ model: IConversationModel) {
        self.tableDataSource = tableDataSource
        self.tableDelegate = tableDelegate
        self.model = model
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        configureTitle(with: model.userName)
        configureTableView()
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToLastRow()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        model.markConversationAsRead()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SendMessageContainerSegue",
            let sendMessageViewController = segue.destination as? SendMessageViewController else {
                assertionFailure("Failed embeded segue")
                return
        }
        sendMessageViewController.model = model
    }
    
    // MARK: - Private methods
    
    private func assertDependencies() {
        assert(tableDataSource != nil && tableDelegate != nil && model != nil)
    }
    
    private func configureTitle(with userName: String) {
        navigationItem.title = userName
    }
    
    private func configureTableView() {
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDelegate
        showNoMessagesBackgroundView(model.isEmpty)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintForKeyboard(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    private func scrollToLastRow() {
        DispatchQueue.main.async {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections - 1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: (numberOfSections - 1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    private func showNoMessagesBackgroundView(_ flag: Bool) {
        flag ? (tableView.backgroundView = noMessagesView) : (tableView.backgroundView = nil)
    }
}

// MARK: - IConversationModelDelegate

extension ConversationViewController: IConversationModelDelegate {
    func userChangesStatusTo(online: Bool) {
        if sendMessageViewController != nil {
            sendMessageViewController.userIsOnline = online
        }
    }
    
    func setup(dataSource: [MessageViewModel]) {
        tableDelegate.setup(dataSource: dataSource)
        tableDataSource.setup(dataSource: dataSource)
        DispatchQueue.main.async {
            self.showNoMessagesBackgroundView(dataSource.isEmpty)
            self.tableView.reloadData()
            self.scrollToLastRow()
        }
    }
}

// MARK: - Keyboard constraint handling

extension ConversationViewController {
    @objc private func updateConstraintForKeyboard(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animationCurveRawNSNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
            let animationCurveRaw = animationCurveRawNSNumber.uintValue
            let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame.origin.y >= UIScreen.main.bounds.height {
                bottomConstraint.constant = 0.0
            } else {
                bottomConstraint.constant = endFrame.size.height
            }
            view.layoutIfNeeded()
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: { _ in self.scrollToLastRow() }
            )}
    }
}

