//
//  SendMessageViewController.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 19/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit

class SendMessageViewController: UIViewController {
    @IBOutlet private weak var sendButton: UIButton! {
        didSet {
            sendButton.isEnabled = false
        }
    }
    @IBOutlet private weak var messageTextView: UITextView!
    
    var model: IConversationModel!
    
    var userIsOnline: Bool = true {
        didSet {
            enableSendButton(userIsOnline)
        }
    }
    
    private static let maxMessageLength = 140
    
    @IBAction private func sendButtonAction(_ sender: UIButton) {
        messageTextView.text = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        model.send(message: messageTextView.text)
        self.messageTextView.text = ""
        self.sendButton.isEnabled = false
    }
    
    private func enableSendButton(_ flag: Bool) {
        DispatchQueue.main.async {
            let conditionToEnableButton = self.userIsOnline && self.messageTextView != nil && self.messageTextView.text != ""
            let currentButtonStateIsDifferent = self.sendButton.isEnabled != conditionToEnableButton
            if currentButtonStateIsDifferent {
                self.sendButton.isEnabled = flag
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension SendMessageViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let conditionToEnableSendButton = text != "" && userIsOnline
            enableSendButton(conditionToEnableSendButton)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let futureText = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
            futureText.replaceCharacters(in: range, with: text)
            return futureText.length < SendMessageViewController.maxMessageLength
        }
        return true
    }
}
