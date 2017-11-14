//
//  FetchedResultsConversationListHelper.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 12/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData
import UIKit

class FetchedResultsConversationListHelper: NSObject, NSFetchedResultsControllerDelegate {
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            deleteRowsInTableAtIndexPath(indexPath)
        case .insert:
            insertRowsInTableAtIndexPath(newIndexPath)
        case .move:
            deleteRowsInTableAtIndexPath(indexPath)
            insertRowsInTableAtIndexPath(newIndexPath)
        default:
            break
        }
    }
    
    private func deleteRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    private func insertRowsInTableAtIndexPath(_ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            tableView.insertRows(at: [indexPath], with: .none)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
}
