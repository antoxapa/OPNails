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
        navigationBarAppearence.backgroundColor = .clear
        navigationBarAppearence.barTintColor = .white
        navigationBarAppearence.tintColor = .black
        navigationBarAppearence.shadowImage = UIImage()

    }
}
