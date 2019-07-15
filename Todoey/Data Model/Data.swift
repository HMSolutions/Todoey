//
//  Data.swift
//  Todoey
//
//  Created by Syeds on 15/07/2019.
//  Copyright © 2019 HMSolutions. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    //in realm you have to mark variable with dynamic keyword so any changes while running can be updated dynamically
    //also use @objc as these are objective c
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
