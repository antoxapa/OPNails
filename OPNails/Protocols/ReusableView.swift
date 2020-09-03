//
//  ReusableView.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/16/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    
    static var nibName: String { get }
    
    static var defaultReusableIdentifier: String { get }
    
}

extension ReusableView where Self: UICollectionViewCell {
    
    static var nibName: String {
        
        return String(describing: Self.self)
        
    }
    
    static var defaultReusableIdentifier: String {
        
        return String(describing: Self.self)
        
    }
}

extension ReusableView where Self: UICollectionReusableView {
    
    static var nibName: String {
        
        return String(describing: Self.self)
        
    }
    
    static var defaultReusableIdentifier: String {
        
        return String(describing: Self.self)
        
    }
    
}
