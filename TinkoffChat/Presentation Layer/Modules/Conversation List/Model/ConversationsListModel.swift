//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData
import UIKit

protocol IConversationsListModel: class {
    func getConversationID(for indexPath: IndexPath) -> String
    func configureWith(_ tableView: UITableView)
}

class ConversationsListModel: NSObject, IConversationsListModel {
    private let communicationService: ICommunicationService
    private let conversationStorageService: IConversationStorageService

    private var fetchResultsController: NSFetchedResultsController<Conversation>
    private var fetchedResultsConversationListHelper: FetchedResultsConversationListHelper!
    
    init(communicationService: ICommunicationService,
         conversationStorageService: IConversationStorageService) {
        self.communicationService = communicationService
        self.conversationStorageService = conversationStorageService
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let sortBySectionsDescriptor = NSSortDescriptor(key: #keyPath(Conversation.isOnline), ascending: false)
        let sortByDateDescriptor = NSSortDescriptor(key: #keyPath(Conversation.lastMessage.date), ascending: false)
        let sortByNameDescriptor = NSSortDescriptor(key: #keyPath(Conversation.participant.name), ascending: false)
        fetchRequest.sortDescriptors = [sortBySectionsDescriptor, sortByDateDescriptor, sortByNameDescriptor]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: conversationStorageService.mainContext,
                                                            sectionNameKeyPath: #keyPath(Conversation.isOnline),
                                                            cacheName: nil)
        super.init()
    }
    
    func configureWith(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        fetchedResultsConversationListHelper = FetchedResultsConversationListHelper(tableView: tableView)
        fetchResultsController.delegate = fetchedResultsConversationListHelper
        do {
            try fetchResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    func getConversationID(for indexPath: IndexPath) -> String {
        guard let conversationID = fetchResultsController.object(at: indexPath).conversationID else {
            preconditionFailure("No conversation found for passed index path")
        }
        return conversationID
    }
}

extension ConversationsListModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath)
        guard let conversationCell = cell as? ConversationCellConfiguration & UITableViewCell else {
            assertionFailure("Wrong cell type")
            return cell
        }
        let conversation = fetchResultsController.object(at: indexPath)
        conversationCell.name = conversation.participant?.name
        conversationCell.message = conversation.lastMessage?.text
        conversationCell.date = conversation.lastMessage?.date?.formattedForMessage()
        conversationCell.online = conversation.isOnline
        conversationCell.hasUnreadMessages = conversation.isUnread
        return conversationCell
    }
    
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchResultsController.sections else {
            preconditionFailure("no sections in fetchedResultsController")
        }
        guard sections[section].numberOfObjects > 0 else {
            return nil
        }
        let conversationInSection = fetchResultsController.object(at: IndexPath(row: 0, section: section))
        return conversationInSection.isOnline ? "Online" : "History"
    }
}

extension ConversationsListModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let conversationCell = cell as? ConversationCellConfiguration else {
            assertionFailure("Wrong cell type in ConversationListViewController")
            return
        }
        conversationCell.applyFontStyle()
    }
}
