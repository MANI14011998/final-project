//
//  Item.swift
//  Todo_with_chatbot
//
//  Created by MANINDER SINGH on 27/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
