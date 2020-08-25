//
//  MonthNameHeaderView.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol HeaderMonthViewUpdatable {
    
    func configure(withItem item: DayRowItem, presenter: MonthPresenting)
    
}

final class MonthNameHeaderView: UICollectionReusableView, ReusableView, HeaderMonthViewUpdatable  {
    
    @IBOutlet weak var monthNameLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var presenter: MonthPresenting?
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        presenter?.showNextMonth()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        
        presenter?.showPreviousMonth()
    }
    
    func configure(withItem item: DayRowItem, presenter: MonthPresenting) {
        
        monthNameLabel.text = "\(item.month), \(item.year)"
        self.presenter = presenter
        
    }
    
    func hideLeftButton() {
        
        leftButton.isHidden = true
        monthNameLabel.textColor = .red
        
    }
    
    func showLeftButton() {
        
        leftButton.isHidden = false
        monthNameLabel.textColor = .black
        
    }
    
    func hideRightButton() {
        
        rightButton.isHidden = true
        
    }
    
    func showRightButton() {
        
        rightButton.isHidden = false
        
    }
}
