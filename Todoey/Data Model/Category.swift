//
//  Category.swift
//  Todoey
//
//  Created by Aaron Lam on 8/23/18.
//  Copyright © 2018 Aaron Lam Developer. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
