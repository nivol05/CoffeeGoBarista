//
//  CashBoxSupplementVC.swift
//  CofeeGo
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class CashBoxSupplementVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func outcomeBtn(_ sender: Any) {
        presentPopup(popupVC: OutcomeVC(), mainVC: self)
    }
    @IBAction func supplyBtn(_ sender: Any) {
//        openInventory = true
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav")
        
        present(viewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func inventoryBtn(_ sender: Any) {
        
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
