//
//  Item+CoreDataProperties.swift
//  Todoey
//
//  Created by Christian Schmutte on 13.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }
    
    @NSManaged public var done: Bool
    @NSManaged public var title: String
    @NSManaged public var parentCategory: Catagory
    
    
}

