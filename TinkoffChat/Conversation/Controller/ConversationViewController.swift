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
    var communicationManager: CommunicationManager! {
        didSet {
            communicationManager.delegate = self
        }
    }
    private lazy var dataSource = ConversationDataSource(conversation: conversation)
    private var sendMessageViewController: SendMessageViewController!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noMessagesView: UIView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if conversation.messages.isEmpty {
            tableView.backgroundView = noMessagesView
        }
        navigationItem.title = conversation.name
        tableView.dataSource = dataSource
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToLastRow()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendMessageContainerSegue", let sendMessageViewController = segue.destination as? SendMessageViewController {
            self.sendMessageViewController = sendMessageViewController
            sendMessageViewController.conversation = self.conversation
            sendMessageViewController.communicationManager = self.communicationManager
        }
    }
    
    // MARK: - Private Methods
    
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
}

// MARK: - Extensions

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
                scrollToLastRow()
            }
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

extension ConversationViewController: CommunicationManagerDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.backgroundView = self.conversation.messages.isEmpty ? self.noMessagesView : nil
            self.sendMessageViewController.shouldEnableSendButton(self.conversation.isOnline)
            self.tableView.reloadData()
            self.scrollToLastRow()
        }
    }
}
