//
//  CalendarPresenter.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/09.
//

import Foundation

import UIKit


class CalendarPresenter{
    
    static let shared = CalendarPresenter()
    private let calendarBuilder = CalendarBuilder()
    private var dataSource = [MonthYearCombination]()
      
    lazy var currentMonth = calendarBuilder.currentMonth()
    
    private init(){}
    
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
     
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    func getWeekDayInNumber(from calenderDay: CalendarDay)->Int{
        let day = calenderDay.day
        var dayCount = 0
        for weekDay in weekDays{
            if day == weekDay{
                break
            }
            dayCount = dayCount + 1
        }
        return dayCount
    }
    
    func getMonthDescriptor(fromMonth month: Int)->String{
        return months[month - 1]
    }
    
    func loadMonth(_ month: Int, andYear year: Int)->[CalendarDay]{
        var monthDays = [CalendarDay]()
        var counts = 0
        var calerdarDate : CalendarDay?
        
        if let daysInMonth = calendarBuilder.getFirstAndLastDayInterval(ofMonth: month, andYear: year){
            var day = 1
            var date = calendarBuilder.firstDay(ofMonth: month, andYear: year)
            if let date = date{
                calerdarDate = calendarBuilder.getDateObject(fromDate: date)
            }
            guard let validDate = calerdarDate else{
                return []
            }
            let startingIndex = getWeekDayInNumber(from: validDate)
            for _ in 0..<startingIndex{
                monthDays.append(CalendarDay())
                counts = counts + 1
            }
            monthDays.append(validDate)
            counts = counts + 1
            while day < daysInMonth {
                date = calendarBuilder.nextDate(fromDate: date!)
                calerdarDate = calendarBuilder.getDateObject(fromDate: date!)
                monthDays.append(calerdarDate!)
                day = day + 1
                counts = counts + 1
            }
            while counts < 42 {
                counts = counts + 1
                monthDays.append(CalendarDay())
            }
        }
        return monthDays
    }
    
    private func insertMonthBackwards(_ currentMonthAndYear: MonthYearCombination){
        var count = 6
       
        var currentMonth = currentMonthAndYear.month
        var currentYear = currentMonthAndYear.year
        
        self.dataSource.insert(currentMonthAndYear, at: count)
        
        while count >= 0 {
            count = count - 1
            if let prevMonthAndYear = calendarBuilder.previousMonthAndYear(fromMonth: currentMonth, andYear: currentYear){
                dataSource.insert(prevMonthAndYear, at: count)
                currentMonth = prevMonthAndYear.month
                currentYear = prevMonthAndYear.year
            }
            count = count - 1
        }
    }
    private func insertBackwards(from currentMonthAndYear: MonthYearCombination) {
        self.dataSource = []
        var count = 6
    
        self.dataSource.insert(currentMonthAndYear, at: 0)
        count = count - 1
        var currentMonth = currentMonthAndYear.month
        var currentYear = currentMonthAndYear.year
        
        while count > 0 {
            if let prevMonthAndYear = calendarBuilder.previousMonthAndYear(fromMonth: currentMonth, andYear: currentYear){
                dataSource.insert(prevMonthAndYear, at: 0)
                currentMonth = prevMonthAndYear.month
                currentYear = prevMonthAndYear.year
            }
            count = count - 1
        }
    }
    private func appendForward(from currentMonthAndYear: MonthYearCombination ){
        var currentMonth = currentMonthAndYear.month
        var currentYear = currentMonthAndYear.year
        
        var count = 0
        
        while count < 6 {
            if let nextMonthAndYear = calendarBuilder.nextMonthAndYear(fromMonth: currentMonth, andYear: currentYear){
                dataSource.append(nextMonthAndYear)
                currentMonth = nextMonthAndYear.month
                currentYear = nextMonthAndYear.year
            }
            count = count + 1
        }
    }

    public func generateCalendarDataSource(_ currentMonthAndYear: MonthYearCombination, completed: @escaping([MonthYearCombination])->Void){
        
        insertBackwards(from: currentMonthAndYear)
        appendForward(from: currentMonthAndYear)
        completed(dataSource)
    }
    
    func indexPathForCurrentMonth(from dataSource:[MonthYearCombination])->IndexPath{
        if let currentMonth = calendarBuilder.currentMonth(){
            var count = 0
            while count < dataSource.count{
                let monthAndYear = dataSource[count]
                if monthAndYear.month == currentMonth{
                    return IndexPath(row: count, section: 0)
                }
                count = count + 1
            }
        }
        return IndexPath(row: 0, section: 0)
    }
    func indexPathForMonth(_ visibleMonth: Int, in dataSource: [MonthYearCombination])->IndexPath?{
        var count = 0
        while count < dataSource.count{
            let monthAndYear = dataSource[count]
            if visibleMonth == monthAndYear.month{
                return IndexPath(row: count, section: 0)
            }
            count = count + 1
        }
        return nil
    }
}
