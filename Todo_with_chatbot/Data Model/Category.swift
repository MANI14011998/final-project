//
//  Category.swift
//  Todo_with_chatbot
//
//  Created by MANINDER SINGH on 27/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
