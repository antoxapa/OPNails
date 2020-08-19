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
    @IBOutlet weak var todayView: UIView!
    
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
        dayLabel.textColor = .black
    }
    
}
