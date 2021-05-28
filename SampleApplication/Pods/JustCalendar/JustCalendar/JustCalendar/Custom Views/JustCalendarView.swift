//
//  JustCalendarView.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/14.
//

import UIKit

public protocol JustCalendarViewDelegate {
    func forwardButtonTapped(_ sender: NavigatorButton)
    func backwardButtonTapped(_ sender: NavigatorButton)
    func selectedDate(_ date: Int, month: Int, year: Int, andDay day:String)
}

public class JustCalendarView: UIView {
    
    public var delegate : JustCalendarViewDelegate?
    
    public var monthYearColor: UIColor = .black{
        didSet{
            navigatorView.monthYearLabelColor = monthYearColor
        }
    }
    
    public var backButtonImage: UIImage?{
        didSet{
            navigatorView.backButtonImage = backButtonImage
        }
    }
    public var nextButtonImage: UIImage?{
        didSet{
            navigatorView.nextButtonImage = nextButtonImage
        }
    }
    
    public var weekDayColor: UIColor = .darkGray
    public var dateColor: UIColor = .darkText
    public var currentDateSelectionColor: UIColor = .systemPink
    public var cellSelectionColor: UIColor = .lightGray
    
    private let calendarBuilder = CalendarBuilder()
    private let presenter = CalendarPresenter.shared
    
    private lazy var visibleMonthYear : MonthYearCombination? = calendarBuilder.currentMonthAndYear()
    private var dataSource = [MonthYearCombination]()
    
    private var navigatorView : JustMonthNavigatorView = {
        let view = JustMonthNavigatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    private var calendarCollectionView : UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(JustMonthCollectionViewCell.self, forCellWithReuseIdentifier: "MAMonthCell")
        return collectionView
    }()
    
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        self.addButtonTapNotification()
        self.setupNavigatorView()
        self.setupCalendarView()
        self.constraintSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.white
        self.addButtonTapNotification()
        self.setupNavigatorView()
        self.setupCalendarView()
        self.constraintSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addButtonTapNotification()
        self.setupNavigatorView()
        self.setupCalendarView()
        self.constraintSubViews()
    }
    
    deinit {
        self.removeButtonTapNotification()
    }
    
    private func setupNavigatorView(){
        self.addSubview(navigatorView)
        self.setMonthAndYearLabel()
    }
    
    private func setupCalendarView(){
        self.addSubview(calendarCollectionView)
        self.setDataSourceAndScrollToVisibleMonth(calendarBuilder.currentMonthAndYear())
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self
       // self.addConstraintsToCalendarView()
    }
    
    
    private func setMonthAndYearLabel() {
        if let monthAndYear = self.visibleMonthYear{
            navigatorView.monthAndYear = monthAndYear
        }
    }
    
    private func setDataSourceAndScrollToVisibleMonth(_ monthYear: MonthYearCombination?){
        if let currentMonthAndYear = monthYear{
            presenter.generateCalendarDataSource(currentMonthAndYear) { dataSource in
                self.dataSource = dataSource
                self.scrollToLastVisibleCell()
            }
        }
    }
    
    private func scrollToLastVisibleCell(){
        guard let monthAndYear  = self.visibleMonthYear else{
            return
        }
        guard let indexPath = presenter.indexPathForMonth(monthAndYear.month, in: self.dataSource) else{
            return
        }
        self.visibleMonthYear = dataSource[indexPath.row]
        
        DispatchQueue.main.async {
            self.calendarCollectionView.reloadData()
            self.calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func selectedDate(_ selectedDate: CalendarDay) {
        if let date = selectedDate.date, let month = selectedDate.month, let year = selectedDate.year, let day = selectedDate.day{
            delegate?.selectedDate(date, month: month, year: year, andDay: day)
        }
        
    }
}

// MARK: - Constraints

extension JustCalendarView{
    
    private func constraintSubViews(){
        self.addConstraintsToNavigatorView()
        self.addConstraintsToCalendarView()
    }
    private func addConstraintsToNavigatorView() {
        let constraints = [
            navigatorView.topAnchor.constraint(equalTo: self.topAnchor),
            navigatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            navigatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            navigatorView.heightAnchor.constraint(equalToConstant: Constants.navigatorViewHeight)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    private func addConstraintsToCalendarView() {
        let constraints = [
            calendarCollectionView.topAnchor.constraint(equalTo: navigatorView.bottomAnchor),
            calendarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            calendarCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - CollectionView Datasource and delegates

extension JustCalendarView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MAMonthCell", for: indexPath) as?  JustMonthCollectionViewCell{
            cell.monthAndYear = self.dataSource[indexPath.row]
            cell.dateColor = self.dateColor
            cell.weekDayColor = self.weekDayColor
            cell.currentCellSelectionColor = self.currentDateSelectionColor
            cell.selectedDateItem = self.selectedDate(_:)
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let collectionViewWidth = collectionView.frame.width
        let collectionViewHeight = collectionView.frame.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0.0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0.0
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        self.visibleMonthYear = self.dataSource[indexPath.row]
        setMonthAndYearLabel()

    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
        if (indexPath.row > self.dataSource.count - 3) || (indexPath.row < 3 && indexPath.row != 0){
            self.setDataSourceAndScrollToVisibleMonth(self.visibleMonthYear)
        }
    }
}
// MARK: - notification for navigation Button tap

extension JustCalendarView{
    private func addButtonTapNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(buttonTapped(_:)), name: Notification.Name.naviagtorButtonTapNotification, object: nil)
    }
    private func removeButtonTapNotification() {
        NotificationCenter.default.removeObserver(self, name: .naviagtorButtonTapNotification, object: nil)
    }
    @objc private func buttonTapped(_ notification: NSNotification){
        let userInfo = notification.userInfo
        if let tappedButton = userInfo?["sender"] as? NavigatorButton{
            if tappedButton.identifier == 99{
                delegate?.backwardButtonTapped(tappedButton)
            }
            else{
                delegate?.forwardButtonTapped(tappedButton)
            }
        }
        else{
            print("Error in getting the button for action.")
        }
    }
    
}
