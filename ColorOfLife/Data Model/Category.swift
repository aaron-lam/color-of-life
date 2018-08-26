//
//  Category.swift
//  ColorOfLife
//
//  Created by Aaron Lam on 8/23/18.
//  Copyright © 2018 Aaron Lam Developer. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
