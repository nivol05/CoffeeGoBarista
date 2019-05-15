//
//  CashBoxSupplementVC.swift
//  CofeeGo
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class CashBoxSupplementVC: UIViewController {

    @IBOutlet weak var checkMarkView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isInventoryInProcess(){
            checkMarkView.isHidden = false
        } else {
            checkMarkView.isHidden = true
        }
        
    }
    
    
    
    @IBAction func outcomeBtn(_ sender: Any) {
        presentPopup(popupVC: OutcomeVC(), mainVC: self)
    }
    @IBAction func supplyBtn(_ sender: Any) {
//        openInventory = true
        
        inventoryType = InventoryType.Income
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav")
        present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func endOfShiftBtn(_ sender: Any) {
        presentPopup(popupVC: EndOfShiftVC(), mainVC: self)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func inventoryBtn(_ sender: Any) {
        
        inventoryType = InventoryType.Inventorization
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav")
        
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func synchronizationBtn(_ sender: Any) {
        
    }
    
    @IBAction func productOutcomeBtn(_ sender: Any) {
        inventoryType = InventoryType.ProductOutcome
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav")
        
        present(viewController, animated: true, completion: nil)
    }
    
}
