//
//  JustCalendarView.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/14.
//

import UIKit

public protocol JustCalendarViewDelegate {
    func selectedDate(_ date: Int, month: Int, year: Int, andDay day:String)
}

public class JustCalendarView: UIView {
    
    // MARK: - public configurables
    
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
    
    public var delegate : JustCalendarViewDelegate?
    
    // MARK: - private class and variables
    
    private let calendarBuilder = CalendarBuilder()
    private let presenter = CalendarPresenter.shared
    
    private var dataSource = [MonthYearCombination]()
    
    // MARK: - private calendar components
    
    private lazy var currentMonthYear : MonthYearCombination? = calendarBuilder.currentMonthAndYear()
    
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
    
    private var cellWidth : CGFloat?{
        return calendarCollectionView.visibleCells.first?.bounds.width
    }
    
    // MARK: - calendar initializers
    
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
    
    // MARK: - deinitializaers
    
    deinit {
        self.removeButtonTapNotification()
    }
    
    // MARK: - Setting up initial values for view properties
    
    private func setMonthAndYearLabel() {
        DispatchQueue.main.async {
            if let monthAndYear = self.currentMonthYear{
                self.navigatorView.monthAndYear = monthAndYear
            }
        }
    }
    
    private func setupNavigatorView(){
        self.addSubview(navigatorView)
        self.setMonthAndYearLabel()
    }
    
    private func setupCalendarView(){
        self.addSubview(calendarCollectionView)
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self
        
        self.currentMonthYear = self.calendarBuilder.currentMonthAndYear()
        self.updateDatasource(self.currentMonthYear)
        
        guard let currentIndexPath = self.getIndexPathForCell(withMonthYear: self.currentMonthYear) else{
            return
        }
        DispatchQueue.main.async {
            self.scrollToCell(withIndexPath: currentIndexPath, animated:  false)
        }
    }
    
    // MARK: - private utility methods
    
    private func reloadMonthCellAfterScrolling() {
        if let indexPath = getIndexPathForCell(withMonthYear: self.currentMonthYear){
            DispatchQueue.main.async {
                self.calendarCollectionView.reloadItems(at: [indexPath])
            }
        }
        else{
            print("reload failed while scrolling")
        }
    }
    
    private func updateDatasource(_ monthYear: MonthYearCombination?){
        if let currentMonthAndYear = monthYear{
            presenter.generateDatasourceRelativeTo(currentMonthAndYear) { dataSource in
                self.dataSource = dataSource
            }
        }
    }
    
    private func getIndexPathForCell(withMonthYear monthAndYear: MonthYearCombination?)->IndexPath?{
        guard let monthAndYear  = monthAndYear else { return nil }
        
        if let indexPath = presenter.indexPathForMonthAndYear(in: self.dataSource, forMonth: monthAndYear.month, andYear: monthAndYear.year) {
            return indexPath
        }
        else{
            return nil
        }
    }
    private func scrollToCell(withIndexPath indexPath: IndexPath, animated: Bool = false){
        DispatchQueue.main.async {
            self.calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        }
    }
    
    private func goToPreviousMonthCell() {
        let cellHeight = calendarCollectionView.bounds.height
        let currentCellStartingXPosition = calendarCollectionView.contentOffset.x
        if let cellWidth = cellWidth{
            let prevCellRect = CGRect(x: currentCellStartingXPosition - cellWidth, y: calendarCollectionView.bounds.origin.y, width: cellWidth, height: cellHeight)
            calendarCollectionView.scrollRectToVisible(prevCellRect, animated: true)
        }
    }
    
    private func gotoNextMonthCell() {

        let cellHeight = calendarCollectionView.bounds.height
        let currentCellStartingXPosition = calendarCollectionView.contentOffset.x
        if let cellWidth = cellWidth{
            let nextCellRect = CGRect(x: currentCellStartingXPosition + cellWidth, y: calendarCollectionView.bounds.origin.y, width: cellWidth, height: cellHeight)
            calendarCollectionView.scrollRectToVisible(nextCellRect, animated: true)
        }
    }
    
    private func selectedDate(_ selectedDate: CalendarDay?) {
        if let selectedDate = selectedDate, let date = selectedDate.date, let month = selectedDate.month, let year = selectedDate.year, let day = selectedDate.day{
            delegate?.selectedDate(date, month: month, year: year, andDay: day)
        }
    }
}

// MARK: - CollectionView DelegateFlowLayout methods

extension JustCalendarView: UICollectionViewDelegateFlowLayout{
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
}

// MARK: - CollectionView Datasource methods

extension JustCalendarView : UICollectionViewDataSource{
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
}

// MARK: - ScrollViewDelegate Methods

extension JustCalendarView: UIScrollViewDelegate{

    //called when scrolling takes place by calling scrollRectToVisible(_:) method
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let cellPosition = self.calendarCollectionView.contentOffset
        if let indexPath = self.calendarCollectionView.indexPathForItem(at: cellPosition){
            
            self.currentMonthYear = self.dataSource[indexPath.row]
            setMonthAndYearLabel()

            if ((indexPath.row > self.dataSource.count - 3) || (indexPath.row <= 3)){
                self.updateDatasource(self.currentMonthYear)
                if let newIndexPath = self.getIndexPathForCell(withMonthYear: self.currentMonthYear){
                    self.scrollToCell(withIndexPath: newIndexPath)
                }
            }
        }
        reloadMonthCellAfterScrolling()
    }
    
   //called when scrolling takes place by swipping
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cellPosition = self.calendarCollectionView.contentOffset
        if let indexPath = self.calendarCollectionView.indexPathForItem(at: cellPosition){
            
            self.currentMonthYear = self.dataSource[indexPath.row]
            setMonthAndYearLabel()

            if ((indexPath.row > self.dataSource.count - 3) || (indexPath.row <= 3)){
                self.updateDatasource(self.currentMonthYear)
                if let newIndexPath = self.getIndexPathForCell(withMonthYear: self.currentMonthYear){
                    self.scrollToCell(withIndexPath: newIndexPath)
                }
            }
        }
        reloadMonthCellAfterScrolling()
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
                goToPreviousMonthCell()
            }
            else{
                gotoNextMonthCell()
            }
        }
        else{
            print("Error in getting the button for action.")
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
