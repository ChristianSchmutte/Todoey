//
//  Item.swift
//  Todoey
//
//  Created by Christian Schmutte on 12.04.19.
//  Copyright © 2019 Christian Schmutte. All rights reserved.
//

import Foundation

class Item {
    var title: String
    var done = false
    
    init(title: String) {
        self.title = title
    }
}
