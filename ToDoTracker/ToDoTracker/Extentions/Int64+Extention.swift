//
//  Int64+Extention.swift
//  ToDoTracker
//
//  Created by Max on 14.08.2025.
//

import Foundation

extension UUID {
    var int64Value: Int64 {
        let uuidBytes = withUnsafeBytes(of: uuid) { Data($0) }
        return uuidBytes.withUnsafeBytes { $0.load(as: Int64.self) }
    }
    
    var positiveInt64Value: Int64 {
        abs(int64Value)
    }
}

