//
//  Item.swift
//  Todoey
//
//  Created by Syeds on 15/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    //backward relationship use linkingobject with reference to category.self object and forward linking property (item in this case)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "item")
}
