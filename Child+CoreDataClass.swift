//
//  Child+CoreDataClass.swift
//  tempTest
//
//  Created by Amanda Green on 8/24/20.
//  Copyright © 2020 Amanda Green. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Child)
public class Child: NSManagedObject {
    var temperatures: [Temperature]? {
        return self.student?.allObjects as? [Temperature]
    }
    
    convenience init?(name: String, classroom: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else {
                return nil
        }
        
        self.init(entity: Child.entity(), insertInto: context)
        
        self.name = name
        self.classroom = classroom
    }
}
