//
//  Item.swift
//  Todoey
//
//  Created by M. Ahmad Ali on 20/03/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var colour: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
