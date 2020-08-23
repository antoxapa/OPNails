//
//  MonthCell.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell, ReusableView {
    
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet private weak var todayView: UIView!
    @IBOutlet private weak var borderView: UIView!
    
    
    func configure(withItem item: DayRowItem) {
        dayLabel.text = item.day
    }
    
    func setupToday() {
        
        todayView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            todayView.heightAnchor.constraint(equalToConstant: self.bounds.height / 2),
//            todayView.widthAnchor.constraint(equalToConstant: self.bounds.height / 2),
//        ])
        print(self.frame.height)
        print(self.frame.width)
        print(todayView.frame.width)
        print(todayView.frame.height)
        
        todayView.layer.cornerRadius = todayView.frame.height / 4
        print(todayView.layer.cornerRadius)
//        todayView.layer.masksToBounds = true
        todayView.backgroundColor = .red
        dayLabel.textColor = .white
        self.borderView.backgroundColor = .yellow
        
    }
    
    func setupDefault() {
        
        todayView.backgroundColor = .blue
        todayView.layer.cornerRadius = 0
        self.borderView.backgroundColor = .yellow
        
    }
    
    func selectModeActivate() {
        
        dayLabel.textColor = .gray
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0).cgColor
        
    }
    
    func selectModeDeactivate() {
        
        dayLabel.textColor = .black
        borderView.layer.borderWidth = 0
        borderView.layer.borderColor = UIColor.clear.cgColor
        borderView.transform = .identity
        self.contentView.backgroundColor = .clear
        
    }
    
    func setSelectedState() {

        borderView.transform = .init(scaleX: 0.8, y: 0.8)
        self.contentView.backgroundColor = .orange
        
    }
    
    func setUnselectedState() {
        
        borderView.transform = .identity
        self.contentView.backgroundColor = .clear
        
    }
    
}
