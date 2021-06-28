//
//  JustDateCollectionViewCell.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/07.
//

import UIKit

class JustDateCollectionViewCell: UICollectionViewCell {
    
    public var dateTitleColor: UIColor = .darkGray{
        didSet{
            dateLabel.textColor = dateTitleColor
        }
    }
    public var dateString : String?{
        didSet{
            dateLabel.text = dateString
        }
    }
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        label.textColor = .darkText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeDateButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customizeDateButton()
    }
    
    private func customizeDateButton(){
        self.addSubview(dateLabel)
        
        let constraints = [
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    public func addFill(withColor color: UIColor){
        self.dateLabel.backgroundColor = color
        self.dateLabel.textColor = .white
    }
    public func removeFill(){
        self.dateLabel.backgroundColor = UIColor.clear
        self.dateLabel.textColor = dateTitleColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dateLabel.layer.cornerRadius = self.frame.height/2
    }
}
