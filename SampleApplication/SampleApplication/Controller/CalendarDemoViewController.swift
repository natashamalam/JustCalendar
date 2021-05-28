//
//  CalendarDemoViewController.swift
//  SampleApplication
//
//  Created by Mahjabin Alam on 2021/05/28.
//

import UIKit
import JustCalendar

class CalendarDemoViewController: UIViewController, JustCalendarViewDelegate {
        

    @IBOutlet weak var calendar: JustCalendarView!{
        didSet{
            calendar.backButtonImage = UIImage(named: "back")
            calendar.nextButtonImage = UIImage(named: "next")
            calendar.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
}

extension CalendarDemoViewController{
    func forwardButtonTapped(_ sender: NavigatorButton) {
        print("Action for forward button tap")
    }
    
    func backwardButtonTapped(_ sender: NavigatorButton) {
        print("Action for backward button tap")
    }
    
    func selectedDate(_ date: Int, month: Int, year: Int, andDay day: String) {
        print("Selected Date: \n")
        print("Date : \(date)")
        print("Month : \(month)")
        print("Year : \(year)")
        print("Day : \(day)")
    }

}

