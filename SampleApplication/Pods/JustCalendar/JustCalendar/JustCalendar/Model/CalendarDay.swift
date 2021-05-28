//
//  CalendarDay.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/09.
//

import Foundation

struct CalendarDay {
    var day: String?
    var date: Int?
    var month: Int?
    var year: Int?
    
    init() {
        self.day = nil
        self.date = nil
        self.month = nil
        self.year = nil
    }
    init(day: String, date: Int, month: Int, year: Int){
        self.date = date
        self.day = day
        self.month = month
        self.year = year
    }
    func toDate()->Date?{
        var dateComponent = DateComponents()
        dateComponent.day = self.date
        dateComponent.month = self.month
        dateComponent.year = self.year
        guard let date = Calendar.current.date(from: dateComponent) else{
            return nil
        }
       
        return date
    }
}
