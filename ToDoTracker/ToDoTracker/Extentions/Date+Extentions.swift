//
//  Date+Extentions.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//

import Foundation

extension Date {
    func formattedToDMY() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
