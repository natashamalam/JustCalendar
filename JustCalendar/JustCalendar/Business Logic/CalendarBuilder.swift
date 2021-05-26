//
//  CalendarBuilder.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/09.
//

import Foundation

class CalendarBuilder{
    
    let calendarObj = NSCalendar(identifier: .gregorian)
    
    func firstDay(ofMonth month: Int, andYear year: Int)->Date?{
        var dateComponent = DateComponents()
        dateComponent.day = 1
        dateComponent.month = month
        dateComponent.year = year
        guard let date = calendarObj?.date(from: dateComponent) else{
            return nil
        }
       
        return date
    }
    
    func lastDay(ofMonth month: Int, andYear year:Int)->Date?{
        guard let firstDate = firstDay(ofMonth: month, andYear: year) else{
            return nil
        }
        var dateComponent = DateComponents()
        dateComponent.month = 1
        dateComponent.day = -1
        
        guard let lastDate = calendarObj?.date(byAdding: dateComponent, to: firstDate) else {
            return nil
        }
        return lastDate
    }
    
    func getDateObject(fromDate date: Date)->CalendarDay?{
        let formatter = DateFormatter()
        formatter.dateFormat = "E YYYY MM dd"
        let dateString = formatter.string(from: date)
        let components = dateString.split(separator: " ")
        
        let weekDay = String(components[0])
        guard let year = Int(components[1]) else{ return nil }
        guard let month = Int(components[2]) else{ return nil }
        guard let date = Int(components[3]) else{ return nil }
        
        return CalendarDay(day: weekDay, date: date, month: month, year: year)
    }
    
    func getFirstAndLastDayInterval(ofMonth month: Int, andYear year: Int)->Int?{
        
        guard let firstDay = firstDay(ofMonth: month, andYear: year) else{
            return nil
        }
        guard let lastDay = lastDay(ofMonth: month, andYear: year) else{
            return nil
        }
        let differrence = calendarObj?.components([.day], from: firstDay, to: lastDay)
        if let differenceInDays = differrence?.day{
            return (differenceInDays + 1)
        }
        return nil
    }
    func nextDate(fromDate date:Date)->Date?{
        var component = DateComponents()
        component.day = 1
        let nextDate = calendarObj?.date(byAdding: component, to: date)
        return nextDate
    }
    func getDateComponent(_ date: Date)->[String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "E YYYY MM dd"
        let dateString = formatter.string(from: date)
        let components = dateString.split(separator: " ").map{ return String($0)}
        return components
    }
    
    func getMonth(from date: Date?)->Int?{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        if let date = date{
            guard let month = Int(formatter.string(from: date)) else{
                return nil
            }
            return month
        }
        return nil
    }
    
    func currentMonth()->Int?{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let currentDate = Date()
        guard let month = Int(formatter.string(from: currentDate)) else{
            return nil
        }
        return month
    }
    
    func nextMonth(_ date: Date)->Int?{
        let nextMonthDate = calendarObj?.date(byAdding: .month, value: 1, to: date)
        return nextMonthDate?.month()
    }
    
    func previousMonth(_ date: Date)->Int?{
        let previousMonthDate = calendarObj?.date(byAdding: .month, value: -1, to: date)
        return previousMonthDate?.month()
    }
    
    func currentMonthAndYear()->MonthYearCombination?{
        guard let month = currentMonth() else{
            return nil
        }
        guard let year = currentYear() else {
            return nil
        }
        return MonthYearCombination(month: month, year: year)
    }
    
    func previousMonthAndYear(fromMonth month: Int, andYear year: Int)->MonthYearCombination?{
        var dateComponent = DateComponents()
        dateComponent.month = month
        dateComponent.year = year
        if let date = calendarObj?.date(from: dateComponent){
            let previousMonthAndYear = calendarObj?.date(byAdding: .month, value: -1, to: date)
            if let prevMonth = previousMonthAndYear?.month(), let prevYear = previousMonthAndYear?.year(){
                let monthAndYearCombination = MonthYearCombination(month: prevMonth, year: prevYear)
                return monthAndYearCombination
            }
        }
        return nil
    }
    func nextMonthAndYear(fromMonth month: Int, andYear year: Int)->MonthYearCombination?{
        var dateComponent = DateComponents()
        dateComponent.month = month
        dateComponent.year = year
        if let date = calendarObj?.date(from: dateComponent){
            let nextMonthAndYear = calendarObj?.date(byAdding: .month, value: 1, to: date)
            if let nextMonth = nextMonthAndYear?.month(), let nextYear = nextMonthAndYear?.year(){
                let monthAndYearCombination = MonthYearCombination(month: nextMonth, year: nextYear)
                return monthAndYearCombination
            }
        }
        return nil
    }
    
    func currentYear()->Int?{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        if let currentYear = Int(formatter.string(from: currentDate)){
            return currentYear
        }
        return nil
    }
    
    func nextYear(_ date: Date)->Int?{
        if let nextYearDate = calendarObj?.date(byAdding: .year, value: 1, to: date){
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY"
            if let nextYear = Int(formatter.string(from: nextYearDate)){
                return nextYear
            }
        }
        return nil
    }
    func previousYear(_ date: Date)->Int?{
        if let prevYearDate = calendarObj?.date(byAdding: .year, value: -1, to: date){
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY"
            if let prevYear = Int(formatter.string(from: prevYearDate)){
                return prevYear
            }
        }
        return nil
    }
}

extension Date{
    func toString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: self)
    }
    
    func printAsString(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        print(dateFormatter.string(from: self))
    }
    
    func date()->Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let dateString = formatter.string(from: self)
        let components = dateString.split(separator: " ")
        return Int(components[0]) ?? 0
    }
    
    func month()->Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let dateString = formatter.string(from: self)
        let components = dateString.split(separator: " ")
        return Int(components[0]) ?? 0
    }
    
    func year()->Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        let dateString = formatter.string(from: self)
        let components = dateString.split(separator: " ")
        return Int(components[0]) ?? -1
    }
}
