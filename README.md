# JustCalendar

JustCalendar is a user friendly, easy to integrate calendar interface that can be added programmatically or from storyboard. 
What makes it so easy to use is its internal layout constraints. Users can just take a view and assign the "JustCalendarView" class. That's it. 

# Screenshoot
![Simulator Screen Shot - iPhone 12 Pro Max - 2021-05-29 at 20 04 23](https://user-images.githubusercontent.com/8694816/120068338-1fcedc80-c0bb-11eb-88e5-e95e37ad3273.png)

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

1. Add a UIView in a UIViewController.
2. Novigate to the Class inspector and assign JustCalendarView in the class field. 
3. Next create an outlet for the calendar view aka 'JustCalendarView' which was added to through the storyboard to customize the look or to implement the delegate methods. 
<pre><code>  
  @IBOutlet weak var calendar: JustCalendarView!{
        didSet{
            calendar.backButtonImage = UIImage(named: "back")
            calendar.nextButtonImage = UIImage(named: "next")
            calendar.delegate = self
        }
    }
<code></pre>    
##### Demo:
![adding_calendar](https://user-images.githubusercontent.com/8694816/120067426-81d91300-c0b6-11eb-976a-542401df6904.gif)

## License
Distributed under the MIT license. See LICENSE for more information.
