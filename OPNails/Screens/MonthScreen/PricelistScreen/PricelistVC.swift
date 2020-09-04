//
//  PricelistVC.swift
//  OPNails
//
//  Created by Антон Потапчик on 9/4/20.
//  Copyright © 2020 TonyPo Production. All rights reserved.
//

import UIKit

class PricelistVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var priceList: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    func setupViews() {
        
        let minScale = scrollView.frame.size.width / priceList.frame.size.width;
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3.0
        scrollView.contentSize = priceList.frame.size
        scrollView.delegate = self
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return priceList
        
    }
    
}
