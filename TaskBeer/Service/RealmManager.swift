//
//  RealmManager.swift
//  TaskBeer
//
//  Created by Paul James on 05.11.2022.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class RealmManager {
    
    
    
    //MARK: - методы для TaskModel
    static func saveTaskModel(model: TaskModel) {
        try! realm.write {
            realm.add(model)
        }
    }
    
    
    static func deleteTaskModel(model: TaskModel) {
        try! realm.write{
            realm.delete(model)
        }
    }
    
    static  func updateTaskModel(model: TaskModel, title: String, priority: Int) {
        try! realm.write{
            model.title = title
            model.priority = priority
        }
    }
    
    static func updateReadyTaskButtonModel(task: TaskModel, bool: Bool) {
        try! realm.write {
            task.taskReady = bool
        }
    }
    
    //MARK: - методы для CalendarModel
    
    static func saveModel(model: CalendarModel) {
         try! realm.write {
             realm.add(model)
         }
     }
     
     static func deleteModel(model: CalendarModel) {
         try! realm.write {
             realm.delete(model)
         }
     }

    
}
