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
    
    var conversation: Conversation!
    var communicationManager: CommunicationManager!
    
    private static let maxMessageLength = 140

    @IBAction private func sendButtonAction(_ sender: UIButton) {
        messageTextView.text = messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        communicationManager.sendMessage(text: messageTextView.text, to: conversation)
        messageTextView.text = ""
        sendButton.isEnabled = false
    }
    
    func shouldEnableSendButton(_ flag: Bool) {
        if let text = messageTextView.text {
            sendButton.isEnabled = flag && text != ""
        }
    }
    
    private func updateTextViewHeight(for text: NSAttributedString) {
        
    }
}

extension SendMessageViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            let conditionToEnableSendButton = text != "" && conversation.isOnline
            shouldEnableSendButton(conditionToEnableSendButton)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let futureText = textView.attributedText.mutableCopy() as? NSMutableAttributedString {
            futureText.replaceCharacters(in: range, with: text)
            updateTextViewHeight(for: futureText)
            return futureText.length < SendMessageViewController.maxMessageLength
        }
        return true
    }
}
