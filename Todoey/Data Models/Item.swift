//
//  Item.swift
//  Todoey
//
//  Created by Christian Schmutte on 12.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import Foundation

class Item: Codable {
    var title = ""
    var done = false
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
