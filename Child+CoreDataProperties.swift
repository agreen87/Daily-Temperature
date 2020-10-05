//
//  Child+CoreDataProperties.swift
//  tempTest
//
//  Created by Amanda Green on 8/24/20.
//  Copyright © 2020 Amanda Green. All rights reserved.
//
//

import Foundation
import CoreData


extension Child {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Child> {
        return NSFetchRequest<Child>(entityName: "Child")
    }

    @NSManaged public var classroom: String?
    @NSManaged public var name: String?
    @NSManaged public var student: NSSet?

}

// MARK: Generated accessors for student
extension Child {

    @objc(addStudentObject:)
    @NSManaged public func addToStudent(_ value: Temperature)

    @objc(removeStudentObject:)
    @NSManaged public func removeFromStudent(_ value: Temperature)

    @objc(addStudent:)
    @NSManaged public func addToStudent(_ values: NSSet)

    @objc(removeStudent:)
    @NSManaged public func removeFromStudent(_ values: NSSet)

}
