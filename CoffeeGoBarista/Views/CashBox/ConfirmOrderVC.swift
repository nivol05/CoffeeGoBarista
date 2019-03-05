//
//  ConfirmOrderVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 2/22/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class ConfirmOrderVC: UIViewController {
    
    @IBOutlet weak var cashTextBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    
    
    var cashTextSelected = false
    var cashText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        
    }
    
    func style() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func changeLanguage(sender: UIButton) {
        if cashTextSelected{
            
            cashText += "\(sender.titleLabel!.text!)"
            cashTextBtn.setTitle(cashText, for: .normal)        }
    
    }

    @IBAction func cashTextBtn(_ sender: Any) {
        cashTextBtn.borderColorV = UIColor.init(red: 1, green: 120/255, blue: 0, alpha: 1)
        cashTextSelected = true
    }
}
