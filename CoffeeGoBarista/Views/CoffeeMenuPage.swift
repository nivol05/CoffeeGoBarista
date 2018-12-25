//
//  CoffeeMenuPage.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/25/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CoffeeMenuPage: UIViewController {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: UIImage(named: "coffeTabIcon"))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
