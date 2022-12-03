//
//  RealmManager.swift
//  TaskBeer
//
//  Created by Paul James on 05.11.2022.
//

import Foundation
import RealmSwift


class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    
    //MARK: - методы для TaskModel
    func saveTaskModel(model: TaskModel) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }
    
    
    func deleteTaskModel(model: TaskModel) {
        try! localRealm.write{
            localRealm.delete(model)
        }
    }
    
    func updateTaskModel(model: TaskModel, title: String, priority: Int) {
        try! localRealm.write{
            model.title = title
            model.priority = priority
        }
    }
    
    func updateReadyTaskButtonModel(task: TaskModel, bool: Bool) {
        try! localRealm.write {
            task.taskReady = bool
        }
    }
    
    //MARK: - методы для CalendarModel
    
//    func saveCalendarModel(model: CalendarModel){
//        try! localRealm.write{
//            localRealm.add(model)
//        }
//    }
//
//    func deleteCalendarModel(model: CalendarModel) {
//        try! localRealm.write {
//            localRealm.delete(model)
//        }
//    }
}
