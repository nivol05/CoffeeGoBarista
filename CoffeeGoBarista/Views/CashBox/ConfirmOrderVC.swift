//
//  ConfirmOrderVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 2/22/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class ConfirmOrderVC: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        
    }
    
    func style() {
        cornerRatio(view: cancelBtn, ratio: 8, masksToBounds: false)
        cornerRatio(view: payBtn, ratio: 8, masksToBounds: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    

}
