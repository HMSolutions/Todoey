//
//  Category.swift
//  Todoey
//
//  Created by Syeds on 15/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    // to create a forward relationship one to many use the List
    var item = List<Item>()
}
