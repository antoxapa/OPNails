//
//  MonthNameHeaderView.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol HeaderMonthViewUpdatable {
    
    func configure(withItem item: DayRowItem, presenter: MonthPresenter)
    
}

final class MonthNameHeaderView: UICollectionReusableView, ReusableView, HeaderMonthViewUpdatable  {
    
    @IBOutlet weak var monthNameLabel: UILabel! {
        didSet {
            monthNameLabel.textColor = .red
        }
    }
    @IBOutlet weak var leftButton: UIButton!
    
    var presenter: MonthPresenter?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        presenter?.showNextMonth()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        
        presenter?.showPreviousMonth()
    }
    
    func configure(withItem item: DayRowItem, presenter: MonthPresenter) {
        monthNameLabel.text = "\(item.month), \(item.year)"
        self.presenter = presenter
        
    }
}
