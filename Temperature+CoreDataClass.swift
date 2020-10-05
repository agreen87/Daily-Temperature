//
//  Temperature+CoreDataClass.swift
//  tempTest
//
//  Created by Amanda Green on 8/24/20.
//  Copyright © 2020 Amanda Green. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Temperature)
public class Temperature: NSManagedObject {
    convenience init?(degrees:String, dateAndTime:String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let context = appDelegate?.persistentContainer.viewContext
            else {
                return nil
        }
        
        self.init(entity: Temperature.entity(), insertInto: context)
        
        self.degrees = degrees
        self.dateAndTime = dateAndTime
    }
}
