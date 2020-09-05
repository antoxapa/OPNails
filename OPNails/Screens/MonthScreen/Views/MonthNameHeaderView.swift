//
//  MonthNameHeaderView.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol HeaderMonthViewUpdatable: AnyObject {
    
    func configure(withItem item: DayRowItem, presenter: MonthPresenting)
    
}

final class MonthNameHeaderView: UICollectionReusableView, ReusableView, HeaderMonthViewUpdatable  {
    
    @IBOutlet weak var monthNameLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    var presenter: MonthPresenting?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        localizeViews()
    }
    
    private func localizeViews() {
        
        mondayLabel.text = i18n.mondayTitle
        tuesdayLabel.text = i18n.tuesdayTitle
        wednesdayLabel.text = i18n.wednesdayTitle
        thursdayLabel.text = i18n.thursdayTitle
        fridayLabel.text = i18n.fridayTitle
        saturdayLabel.text = i18n.saturdayTitle
        sundayLabel.text = i18n.sundayTitle
        
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        presenter?.showNextMonth()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        
        presenter?.showPreviousMonth()
    }
    
    func configure(withItem item: DayRowItem, presenter: MonthPresenting) {
        
        monthNameLabel.text = "\(item.month) \(item.year)"
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
