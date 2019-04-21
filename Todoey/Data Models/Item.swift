//
//  Item.swift
//  Todoey
//
//  Created by Christian Schmutte on 18.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var itemColorHex: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
