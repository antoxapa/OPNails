//
//  LoadingVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 8/25/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
    }
    
}
