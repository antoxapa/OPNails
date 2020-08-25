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

        print("loading screen")
        activityIndicator.startAnimating()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
