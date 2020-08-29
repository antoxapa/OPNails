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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with item: EntryRowItem) {
        
        timeLabel.text = item.time
        if item.user?.name != "" && item.user != nil {
            userLabel.text = item.user?.name
        } else {
             userLabel.text = "Time available"
        }
    }
    
    func selectedState() {
       
        timeLabel.textColor = .black
        userLabel.font = userLabel.font.withSize(25)
        userLabel.text = "Your time!"
        userLabel.textColor = .systemGreen
        
    }
    
    func unselectedState() {
        
        timeLabel.textColor = .gray
        userLabel.font = userLabel.font.withSize(17)
        userLabel.textColor = .gray
        
    }
    
}
