//
//  TaskEntity+CoreDataProperties.swift
//  ToDoTracker
//
//  Created by Max on 13.08.2025.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var userId: Int64

}

extension TaskEntity : Identifiable {

}
