//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData
import UIKit

class ConversationModel: NSObject, IConversationModel {
    weak var delegate: IConversationModelDelegate?
    
    private let communicationService: ICommunicationService
    private let conversationStorageService: IConversationStorageService
    private let conversationID: String
    
    private let fetchResultsController: NSFetchedResultsController<Message>
    private var fetchedResultsConversationHelper: FetchedResultsConversationHelper!
    private var tableView: UITableView!
    
    let userName: String
    
    var isOnline: Bool {
        return conversationStorageService.isOnline(conversationID: conversationID)
    }
    
    init(communicationService: ICommunicationService, conversationStorageService: IConversationStorageService, conversationID: String) {
        self.communicationService = communicationService
        self.conversationStorageService = conversationStorageService
        self.conversationID = conversationID
        
        self.userName = conversationStorageService.getUserNameForConversationWith(conversationID: conversationID) ?? ""
        
        let mainContext = conversationStorageService.mainContext
        
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequestMessage(withConversationID: conversationID, in: conversationStorageService.mainContext)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Message.date), ascending: true)]
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: mainContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(managedObjectContextDidSave(_:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: mainContext)
    }
    
    // MARK: - API
    
    func configureWith(_ tableView: UITableView) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchedResultsConversationHelper = FetchedResultsConversationHelper(tableView: tableView)
        fetchResultsController.delegate = fetchedResultsConversationHelper
        do {
            try fetchResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    @objc func managedObjectContextDidSave(_ notification: NSNotification) {
        delegate?.userChangesStatusTo(online: conversationStorageService.isOnline(conversationID: conversationID))
    }
    
    func markConversationAsRead() {
        conversationStorageService.markAsReadConversationWith(id: conversationID)
    }
    
    func send(message: String) {
        communicationService.sendMessage(text: message, to: conversationID)
    }
}

// MARK: - UITableViewDataSource

extension ConversationModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchResultsController.sections?.count else {
            preconditionFailure("no sections in fetchedResultsController")
        }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultsController.sections else {
            preconditionFailure("no sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchResultsController.object(at: indexPath)
        let messageCellIdentifier: String
        if message.isOutgoing {
            messageCellIdentifier = MessageCell.outgoingCellIdentifier
        } else {
            messageCellIdentifier = MessageCell.incomingCellIdentifier
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: messageCellIdentifier, for: indexPath)
        guard let messageCell = cell as? MessageCellConfiguration & UITableViewCell else {
            assertionFailure("Wrong cell type")
            return cell
        }
        messageCell.message = message.text
        return messageCell
    }
}

// MARK: - UITableViewDelegate

extension ConversationModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let messageCell = cell as? MessageCellConfiguration & UITableViewCell else {
            assertionFailure("Wrong cell type")
            return
        }
        let message = fetchResultsController.object(at: indexPath)
        cell.layoutIfNeeded()
        if message.isOutgoing {
            messageCell.configure(for: .outgoing)
        } else {
            messageCell.configure(for: .incoming)
        }
    }
}
