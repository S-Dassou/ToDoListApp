//
//  Task.swift
//  ToDoListApp
//
//  Created by shafique dassu on 16/04/2023.
//

import Foundation
import RealmSwift

class Task {
    let id: String
    let title: String
    let description: String
    let category: Category
    var  isComplete: Bool
    init(id: String, title: String, description: String, category: Category, isComplete: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.isComplete = isComplete
    }
    func toggleIsComplete() {
        isComplete = !isComplete
    }
}

class LocalTask: Object {
    @Persisted (primaryKey: true) var id = ""
    @Persisted var taskTitle: String = ""
    @Persisted var taskDescription: String = ""
    @Persisted var category: String = ""
    @Persisted var isComplete: Bool = false
    
}
