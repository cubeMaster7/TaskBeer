//
//  TaskModel.swift
//  TaskBeer
//
//  Created by Paul James on 05.11.2022.
//

import Foundation
import RealmSwift

class TaskModel: Object {
    @Persisted var title: String
    @Persisted var priority: Int
    @Persisted var taskReady: Bool = false
    @Persisted var taskDate: Date? 
}
