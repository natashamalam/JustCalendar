//
//  JustMonthNavigatorView.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/09.
//

import UIKit


class JustMonthNavigatorView: UIView {
    
    private let presenter = CalendarPresenter.shared
    
    public var monthYearLabelColor: UIColor = .black{
        didSet{
            monthYearLabel.textColor = monthYearLabelColor
        }
    }
    
    public var monthAndYear : MonthYearCombination?{
        didSet{
            updateMonthAndYearLabel()
        }
    }
    
    public var backButtonImage: UIImage?{
        didSet{
            backButton.setTitle("", for: .normal)
            backButton.setImage(backButtonImage, for: .normal)
        }
    }
    public var nextButtonImage: UIImage?{
        didSet{
            nextButton.setTitle("", for: .normal)
            nextButton.setImage(nextButtonImage, for: .normal)
        }
    }
    
    public var addNextButton: Bool = true
    public var addBackButton: Bool = true
    
    fileprivate var nextdButtonTapped : ((_ sender: NavigatorButton)-> Void)?
    fileprivate var backButtonTapped : ((_ sender: NavigatorButton)-> Void)?
    
    private var nextButton: NavigatorButton = {
        let button = NavigatorButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.identifier = 100
        return button
    }()
    
    private var backButton: NavigatorButton = {
        let button = NavigatorButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("Prev", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.identifier = 99
        return button
    }()
    
    private var monthYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 25.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeNavigatorView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeNavigatorView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.naviagtorButtonTapNotification, object: nil)
    }
    
    private func customizeNavigatorView(){
        self.backgroundColor = UIColor.white
        if addBackButton{
            self.addSubview(backButton)
            addConstraintsToBackbutton()
        }
        
        self.addSubview(monthYearLabel)
        addConstraintsToMonthYearLabel()
        if addNextButton{
            self.addSubview(nextButton)
            addConstraintsToNextbutton()
        }
    }
    
    private func addConstraintsToBackbutton(){
        let constraints = [
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            backButton.topAnchor.constraint(equalTo: self.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    private func addConstraintsToMonthYearLabel(){
        let constraints = [
            monthYearLabel.heightAnchor.constraint(equalToConstant: 50),
            monthYearLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            monthYearLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            monthYearLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    private func addConstraintsToNextbutton(){
        let constraints = [
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 80),
            nextButton.topAnchor.constraint(equalTo: self.topAnchor),
            nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    private func updateMonthAndYearLabel() {
        if let month = monthAndYear?.month, let year = monthAndYear?.year{
            monthYearLabel.text = presenter.getMonthDescriptor(fromMonth: month) + " \(year)"
        }
    }
    
}

