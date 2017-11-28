//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    private var model: IConversationModel!
    
    private var sendMessageViewController: SendMessageViewController! // Set by the embed segue
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noMessagesView: UIView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    private var animatableTitleLabel = ConversationTitleLabel()
    
    // MARK: Dependency injection
    
    func setDependencies(_ model: IConversationModel) {
        self.model = model
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        configureTitle(with: model.userName)
        model.configureWith(tableView)
        registerForKeyboardNotifications()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendMessageViewController.userIsOnline = model.isOnline
        animateTitleLabelIfNeeded(online: model.isOnline)
        model.markConversationAsRead()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let sendMessageViewControllerHeight = sendMessageViewController.view.bounds.height
        let tableViewContentInset = UIEdgeInsets(top: 0, left: 0, bottom: sendMessageViewControllerHeight, right: 0)
        tableView.contentInset = tableViewContentInset
        tableView.scrollIndicatorInsets = tableViewContentInset
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
        self.sendMessageViewController = sendMessageViewController
        sendMessageViewController.model = model
    }
    
    // MARK: - Private methods
    
    private func assertDependencies() {
        assert(model != nil)
    }
    
    private func configureTitle(with userName: String) {
        animatableTitleLabel.text = userName
        navigationItem.titleView = animatableTitleLabel
    }
    
    private func animateTitleLabelIfNeeded(online: Bool) {
        animatableTitleLabel.isOnline = online
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateConstraintForKeyboard(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
}

// MARK: - IConversationModelDelegate

extension ConversationViewController: IConversationModelDelegate {
    func userChangesStatusTo(online: Bool) {
        if sendMessageViewController != nil {
            animateTitleLabelIfNeeded(online: online)
            sendMessageViewController.userIsOnline = online
        }
    }
}

// MARK: - Keyboard constraint handling

extension ConversationViewController {
    @objc private func updateConstraintForKeyboard(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            let animationCurveRawNSNumber = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
            let animationCurveRaw = animationCurveRawNSNumber.uintValue
            let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
            let contentInset: UIEdgeInsets
            let keyboardWillHide = keyboardFrame.origin.y >= UIScreen.main.bounds.height
            if keyboardWillHide {
                contentInset = UIEdgeInsets(top: 0, left: 0, bottom: sendMessageViewController.view.frame.height, right: 0)
                bottomConstraint.constant = 0.0
            } else {
                bottomConstraint.constant = keyboardFrame.height
                let sendMessageViewControllerHeight = sendMessageViewController.view.frame.height
                contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + sendMessageViewControllerHeight, right: 0)
            }
            UIView.animate(withDuration: duration, delay: 0, options: animationCurve, animations: {
                self.view.layoutIfNeeded()
                self.updateTableViewWith(contentInset: contentInset)
            })
        }
    }
    
    private func updateTableViewWith(contentInset: UIEdgeInsets) {
        self.tableView.contentInset = contentInset
        self.tableView.scrollIndicatorInsets = contentInset
        let tableEffectiveHeight = self.tableView.bounds.height - contentInset.bottom
        let contentExceedsVisiblePart = self.tableView.contentSize.height > tableEffectiveHeight
        if contentExceedsVisiblePart {
            self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.height + contentInset.bottom), animated: true)
        } else {
            self.tableView.setContentOffset(.zero, animated: true)
        }
    }
}
