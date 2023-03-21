//
//  Category.swift
//  Todoey
//
//  Created by M. Ahmad Ali on 20/03/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items  = List<Item>()
    
}
 
