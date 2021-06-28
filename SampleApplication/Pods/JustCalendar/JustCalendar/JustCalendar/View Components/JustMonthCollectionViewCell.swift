//
//  JustMonthCollectionViewCell.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/13.
//

import UIKit


class JustMonthCollectionViewCell: UICollectionViewCell {
    
    private let weekDays = CalendarPresenter.shared.weekDays

    var selectedDateItem : ((_ dateItem: CalendarDay)->Void)?
    var selectedDate : CalendarDay?
    
    var monthDays : [CalendarDay?] = []{
        didSet{
            self.dateViewCollectionView.reloadData()
        }
    }
    public var weekDayColor: UIColor = .darkGray{
        didSet{
            self.dateViewCollectionView.reloadData()
        }
    }
    public var dateColor: UIColor = .darkText{
        didSet{
            self.dateViewCollectionView.reloadData()
        }
    }
    public var currentCellSelectionColor: UIColor = .green{
        didSet{
            self.dateViewCollectionView.reloadData()
        }
    }
    public var cellSelectionColor: UIColor = .lightGray{
        didSet{
            self.dateViewCollectionView.reloadData()
        }
    }
    
    var monthAndYear : MonthYearCombination?
    
    private let calendarBuilder = CalendarBuilder()
    private let presenter = CalendarPresenter.shared
    
    
    private var dateViewCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(JustDateCollectionViewCell.self, forCellWithReuseIdentifier: "MADateCell")
        return collectionView
    }()
    
    
    private func setMonthInMonthView(){
        self.monthDays = []
        if let month = monthAndYear?.month, let year = monthAndYear?.year{
            self.monthDays = presenter.loadMonth(month, andYear: year)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeCollectionView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeCollectionView()
    }
    deinit {
        dateViewCollectionView.reloadData()
    }
    
    func customizeCollectionView(){
        setMonthInMonthView()
        self.addSubview(dateViewCollectionView)
        dateViewCollectionView.dataSource = self
        dateViewCollectionView.delegate = self
        addConstraints()
    }
    
    func addConstraints(){
        let constraints = [
            dateViewCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            dateViewCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dateViewCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dateViewCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        setMonthInMonthView()
    }
    
}
extension JustMonthCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return presenter.weekDays.count
        }
        return self.monthDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MADateCell", for: indexPath) as?  JustDateCollectionViewCell{
           
            if indexPath.section == 0{
                cell.dateTitleColor = weekDayColor
                cell.dateString = weekDays[indexPath.row]
            }
            else{
                cell.dateTitleColor = dateColor
                if let calendarDay = self.monthDays[indexPath.row]{
                    if calendarBuilder.isCurrentDate(calendarDay){
                        cell.addFill(withColor: currentCellSelectionColor)
                    }
                    if let date = calendarDay.date{
                        cell.dateString = "\(date)"
                    }
                    else{
                        cell.dateString = ""
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let collectionViewWidth = collectionView.bounds.width/7
        return CGSize(width: collectionViewWidth, height: collectionViewWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? JustDateCollectionViewCell{
            cell.removeFill()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if let dateItem = self.monthDays[indexPath.row], calendarBuilder.isValidDate(dateItem){
               
                if let cell = collectionView.cellForItem(at: indexPath) as? JustDateCollectionViewCell{
                    if selectedDate == dateItem{
                        if calendarBuilder.isCurrentDate(dateItem){
                            cell.removeFill()
                            cell.addFill(withColor: currentCellSelectionColor)
                        }
                        else{
                            cell.removeFill()
                        }
                        self.selectedDateItem?(CalendarDay())
                        self.selectedDate = nil
                    }
                    else{
                        cell.addFill(withColor: cellSelectionColor)
                        self.selectedDateItem?(dateItem)
                        self.selectedDate = dateItem
                    }
                }
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? JustDateCollectionViewCell{
            if let calendarDay = self.monthDays[indexPath.row], calendarBuilder.isValidDate(calendarDay) {
                if calendarBuilder.isCurrentDate(calendarDay){
                    cell.removeFill()
                    cell.addFill(withColor: currentCellSelectionColor)
                }
                else{
                    cell.removeFill()
                }
            }
        }
    }
}
