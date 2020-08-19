//
//  Appearance.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

final class Appearance {
    static func setup() {
        
        let navigationBarAppearence = UINavigationBar.appearance()
        navigationBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBarAppearence.isTranslucent = false
        navigationBarAppearence.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        navigationBarAppearence.tintColor = .black
        navigationBarAppearence.shadowImage = UIImage()
        
        let navigationToolBarAppearence = UIToolbar.appearance()
        navigationToolBarAppearence.barTintColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        navigationToolBarAppearence.isTranslucent = false
        navigationToolBarAppearence.backgroundColor = .clear
        navigationToolBarAppearence.tintColor = .black
        
    }
}
