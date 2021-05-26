//
//  MonthYearCombination.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/15.
//

import Foundation

struct MonthYearCombination: CustomStringConvertible {
    var description: String{
        return "month = \(month) and year = \(year)"
    }
    
    var month: Int
    var year: Int
    
    
}
