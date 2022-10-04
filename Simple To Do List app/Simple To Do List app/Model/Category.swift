//
//  Category.swift
//  Simple To Do List app
//
//  Created by Leonardo Cardoso on 04/10/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
