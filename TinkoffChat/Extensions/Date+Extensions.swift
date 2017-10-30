//
//  Date+Extensions.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 29/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

extension Date {
    private struct Formatters {
        static let todaysFormatter = { () -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
        
        static let pastDaysFormatter = { () -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            return formatter
        }()
    }
    
    func formattedForMessage() -> String {
        if Calendar.current.compare(Date(), to: self, toGranularity: .day) == .orderedSame {
            return Formatters.todaysFormatter.string(from: self)
        } else {
            return Formatters.pastDaysFormatter.string(from: self)
        }
    }
}
