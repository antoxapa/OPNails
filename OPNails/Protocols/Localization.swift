//
//  Localization.swift
//  OPNails
//
//  Created by Антон Потапчик on 9/4/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var localized: String {
        
        return NSLocalizedString(self, comment: "")
        
    }
    
    func localized(with values: CVarArg...) -> String {
        
        return String.init(format: NSLocalizedString(self, comment: ""), arguments: values)
        
    }
    
}

extension UIButton {
    
    @IBInspectable
    var localizedStringKey: String? {
        
        set {
            guard let key = newValue else { return }
            
            setTitle(key.localized, for: [])
        }
        
        get { return nil }
    }
    
}

extension UIBarButtonItem {
    
    @IBInspectable
    var localizedStringKey: String? {
        
        set {
            guard let key = newValue else { return }
            
            title = key.localized
        }
        
        get { return nil }
    }
    
}

extension UILabel {
    
    @IBInspectable
    var localizedStringKey: String? {
        
        set {
            
            guard let key = newValue else { return }
            
            text = key.localized
        }
        
        get { return nil }
    }
    
}

extension UITextField {
    
    @IBInspectable
    var localizedStringKey: String? {
        
        set {
            
            guard let key = newValue else { return }
            
            placeholder = key.localized
        }
        
        get { return nil }
    }
    
}

extension UINavigationItem {
    
    @IBInspectable
    var localizedStringKey: String? {
        
        set {
            
            guard let key = newValue else { return }
            
            title = key.localized
        }
        
        get { return nil }
    }
    
}
