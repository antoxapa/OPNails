//
//  MonthNameHeaderView.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

final class MonthNameHeaderView: UICollectionReusableView, ReusableView {
    
    @IBOutlet weak var monthNameLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
    }
    
    func configure(withItem item: DayRowItem) {
        monthNameLabel.text = item.month
    }
}
