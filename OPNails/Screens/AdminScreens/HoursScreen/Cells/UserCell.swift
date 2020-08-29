//
//  UserCell.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/29/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    func configure(item: OPUser) {
        
        userLabel.text = item.name
        
    }
    
}
