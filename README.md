# JustCalendar

JustCalendar is a user friendly, easy to integrate calendar interface that can be added programmatically or from storyboard. 
What makes it so easy to use is its internal layout constraints. Users can just take a view and assign the "JustCalendarView" class. That's it. 

# Requirements
 - *iOS 11.0*
 - *Swift 5.0*

# Installation
  - Go to the terminal and naviagte to the project directory. First create the PodFile with "pod init". 
  - Open the PodFile and add "pod 'JustCalendar'". 
  - Save and close the file. 
  - Now do "pod install" which will create the workspace with the library.

# Calendar Customizable properties: 
```
  - var monthYearColor: UIColor 
  - var backButtonImage: UIImage?
  - var nextButtonImage: UIImage?
  - var weekDayColor: UIColor
  - var dateColor: UIColor 
  - var currentDateSelectionColor: UIColor
  - var cellSelectionColor: UIColor
```
#### JustCalendar Delegates: 

    func forwardButtonTapped(_ sender: NavigatorButton)
    func backwardButtonTapped(_ sender: NavigatorButton)
    func selectedDate(_ date: Int, month: Int, year: Int, andDay day:String)

##### Sample intregartion processs:

Add a UIView in a Controller and in the Class inspector, assign JustCalendarView in the class field. Then create an outlet, if you want to customize the calendar view or get the selected date with the delegate. 
  
  @IBOutlet weak var calendar: JustCalendarView!{
        didSet{
            calendar.backButtonImage = UIImage(named: "back")
            calendar.nextButtonImage = UIImage(named: "next")
            calendar.delegate = self
        }
    }
##### Demo:

## License
Distributed under the MIT license. See LICENSE for more information.
