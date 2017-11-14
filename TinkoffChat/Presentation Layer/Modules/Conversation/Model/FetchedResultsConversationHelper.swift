//
//  FetchedResultsConversationHelper.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 13/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData
import UIKit

class FetchedResultsConversationHelper: NSObject, NSFetchedResultsControllerDelegate {
    private let tableView: UITableView
    private var shouldScrollToBottom = false
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let adjustedTableViewFrameSize = self.tableView.frame.height - self.tableView.contentInset.bottom
            let contentExceedsTableViewFrame = self.tableView.contentSize.height > adjustedTableViewFrameSize
            if self.shouldScrollToBottom && contentExceedsTableViewFrame {
                let offset = CGPoint(x: 0, y: self.tableView.contentSize.height - adjustedTableViewFrameSize)
                self.tableView.setContentOffset(offset, animated: true)
            }
            self.shouldScrollToBottom = false
        }
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            deleteRowsInTableAtIndexPath(indexPath)
        case .insert:
            self.shouldScrollToBottom = true
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
}
