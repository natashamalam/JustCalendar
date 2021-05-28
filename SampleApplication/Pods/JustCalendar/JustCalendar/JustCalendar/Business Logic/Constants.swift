//
//  Constants.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/14.
//

import Foundation
import UIKit

struct Constants{
    static let navigatorViewHeight = CGFloat(50.0)
    static let calenderViewHeight = UIScreen.main.bounds.width
    static let minimumMonthNumber : Int = 1
    static let maximumMonthNumber : Int = 12
    
    static let dateViewGrids : Int = 42
    
}
extension Notification.Name{
    static let naviagtorButtonTapNotification = Notification.Name("com.roleWithVirtualization.MANaviagtorButtonTapNotification")
}
