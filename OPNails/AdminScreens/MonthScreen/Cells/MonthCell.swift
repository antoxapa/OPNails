//
//  MonthCell.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class MonthCell: UICollectionViewCell, ReusableView {
    
    @IBOutlet private weak var monthLabel: UILabel!
    
    func configure(withItem item: DayRowItem) {
        monthLabel.text = item.day
    }
    
}
