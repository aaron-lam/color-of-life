//
//  Item.swift
//  Todoey
//
//  Created by Aaron Lam on 8/23/18.
//  Copyright © 2018 Aaron Lam Developer. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
