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
    @IBOutlet weak var eventView: UIView! {
        didSet {
            eventView.isHidden = true
            eventView.layer.cornerRadius = self.frame.height / 6
            eventView.layer.masksToBounds = true
        }
    }
    
    func configure(withItem item: DayRowItem) {
        
        dayLabel.text = item.day
        
    }
    
    func setupRedView() {
        
        eventView.isHidden = false
        eventView.backgroundColor = .red
        
    }
    
    func setupGreenView() {
        
        eventView.isHidden = false
        eventView.backgroundColor = .green
        
    }
    
    func setupEventViewHidden() {
        
        eventView.backgroundColor = .clear
        eventView.isHidden = true
        
    }
    
    func setupToday() {
        
        todayView.translatesAutoresizingMaskIntoConstraints = false
        todayView.layer.cornerRadius = self.frame.height / 4
        todayView.layer.masksToBounds = true
        todayView.backgroundColor = .red
        dayLabel.textColor = .white
        borderView.backgroundColor = .white
        
    }
    
    func setupDefault() {
        
        eventView.isHidden = true
        todayView.layer.cornerRadius = 0
        todayView.backgroundColor = .white
        self.borderView.backgroundColor = .white
        
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
    
    func setDisable() {
        
        dayLabel.textColor = .gray
        eventView.isHidden = true
        todayView.layer.cornerRadius = 0
        todayView.backgroundColor = .white
        borderView.layer.borderWidth = 0
        borderView.layer.borderColor = UIColor.clear.cgColor
        borderView.transform = .identity
        self.contentView.backgroundColor = .clear
        self.borderView.backgroundColor = .white
        
    }
    
}
