//
//  HoursCell.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/17/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class HoursCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    func configure(with item: EntryRowItem) {
        
        timeLabel.text = item.time
        guard
            let name = item.user?.name,
            !name.isEmpty
            else {
                userLabel.text = i18n.timeAvailable
                return
        }
        userLabel.text = item.user?.name
        
    }
    
    func selectedState() {
        
        timeLabel.textColor = .black
        userLabel.font = userLabel.font.withSize(25)
        userLabel.text = i18n.timeYours
        userLabel.textColor = .systemGreen
        
    }
    
    func unselectedState() {
        
        timeLabel.textColor = .gray
        userLabel.font = userLabel.font.withSize(17)
        userLabel.textColor = .gray
        
    }
    
}
