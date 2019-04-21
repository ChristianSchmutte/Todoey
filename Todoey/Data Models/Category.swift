//
//  Category.swift
//  Todoey
//
//  Created by Christian Schmutte on 18.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colorHex: String = ""
    let items = List<Item>()
}
