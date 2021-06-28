//
//  NavigatorButton.swift
//  JustCalendar
//
//  Created by Mahjabin Alam on 2021/05/14.
//

import UIKit


public class NavigatorButton: UIButton {
    
    var identifier: Int = 0
    
    init(){
        super.init(frame: .zero)
        customizeButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeButton()
    }
    
    private func customizeButton() {
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
    }
    
    @objc private func touchUpInside(_ sender: NavigatorButton){
        let userInfo = ["sender": sender]
        NotificationCenter.default.post(name: Notification.Name.naviagtorButtonTapNotification, object: nil, userInfo: userInfo)
    }

}
