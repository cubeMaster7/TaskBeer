//
//  CalendarModel.swift
//  TaskBeer
//
//  Created by Paul James on 03.12.2022.
//


import Foundation
import RealmSwift

class CalendarModel: Object {
    @objc dynamic  var whatDrink = ""
    @objc dynamic  var amountOfAlcohol: String?
    @objc dynamic  var whereDrink: String?
    @objc dynamic  var calendarDate: Date?
//    @Persisted var calendarDate: String
    @objc dynamic  var imageData: Data?
    @objc dynamic  var  date =  Date()
    
    
    convenience init(whatDrink: String, amountOfAlcohol: String?, whereDrink: String?, calendarDate: Date?, imageData: Data?) {
        self.init()
        self.whatDrink = whatDrink
        self.amountOfAlcohol = amountOfAlcohol
        self.whereDrink = whereDrink
        self.calendarDate = calendarDate
        self.imageData = imageData
    }

}
