//
//  MonthCell.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell, ReusableView {
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var todayView: UIView!
    @IBOutlet private weak var borderView: UIView!
    
    var isSelectedState: Bool = false
    
    func configure(withItem item: DayRowItem) {
        dayLabel.text = item.day
    }
    
    func setupToday() {
        
        todayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todayView.heightAnchor.constraint(equalToConstant: self.bounds.height / 2),
            todayView.widthAnchor.constraint(equalToConstant: self.bounds.width / 2),
        ])
        
        todayView.layer.cornerRadius = todayView.bounds.height / 2
        todayView.clipsToBounds = true
        todayView.backgroundColor = .red
        dayLabel.textColor = .white
    }
    
    func setupDefault() {
        
        todayView.backgroundColor = .white
        //        dayLabel.textColor = .black
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
        isSelectedState = !isSelectedState
        borderView.transform = .init(scaleX: 0.8, y: 0.8)
        self.contentView.backgroundColor = .orange
        
    }
    
    func setUnselectedState() {
        isSelectedState = !isSelectedState
        borderView.transform = .identity
        self.contentView.backgroundColor = .clear
        
    }
    
}
