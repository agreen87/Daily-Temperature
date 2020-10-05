//
//  Temperature+CoreDataProperties.swift
//  tempTest
//
//  Created by Amanda Green on 8/24/20.
//  Copyright © 2020 Amanda Green. All rights reserved.
//
//

import Foundation
import CoreData


extension Temperature {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Temperature> {
        return NSFetchRequest<Temperature>(entityName: "Temperature")
    }

    @NSManaged public var dateAndTime: String?
    @NSManaged public var degrees: String?
    @NSManaged public var child: Child?

}
