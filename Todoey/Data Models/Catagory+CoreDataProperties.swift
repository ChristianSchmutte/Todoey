//
//  Catagory+CoreDataProperties.swift
//  Todoey
//
//  Created by Christian Schmutte on 14.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//
//

import Foundation
import CoreData


extension Catagory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Catagory> {
        return NSFetchRequest<Catagory>(entityName: "Catagory")
    }

    @NSManaged public var name: String
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Catagory {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
