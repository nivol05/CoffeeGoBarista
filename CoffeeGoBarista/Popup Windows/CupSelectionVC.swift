//
//  CupSelectionVC.swift
//  CofeeGo
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class CupSelectionVC: UIViewController {
    
    @IBOutlet weak var cupS: UIButton!
    @IBOutlet weak var sizeS: UILabel!
    @IBOutlet weak var priceS: UILabel!
    @IBOutlet weak var cupM: UIButton!
    @IBOutlet weak var sizeM: UILabel!
    @IBOutlet weak var priceM: UILabel!
    @IBOutlet weak var cupL: UIButton!
    @IBOutlet weak var sizeL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var stackL: UIStackView!
    
    
    var product: ElementProduct!
    var cups : [CupSelectElem]!
    var cashBoxVC: MainCashBoxVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCups()
        // Do any additional setup after loading the view.
    }
    
    func checkCups(){
        if (cups.count >= 3){
            stackL.isHidden = false
            priceL.text = "\(cups[2].price!)".getSignedStr()
            sizeL.text = cups[2].size
        } else{
            stackL.isHidden = true
        }
        
        priceM.text = "\(cups[1].price!)".getSignedStr()
        sizeM.text = cups[1].size
        
        priceS.text = "\(cups[0].price!)".getSignedStr()
        sizeS.text = cups[0].size
    }

    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cupSAction(_ sender: Any) {
        cashBoxVC.addOrderItem(cashOrderItem: ProductOrderItem(product: product, cupSize: 1))
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cupMAction(_ sender: Any) {
        cashBoxVC.addOrderItem(cashOrderItem: ProductOrderItem(product: product, cupSize: 2))
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cupLAction(_ sender: Any) {
        cashBoxVC.addOrderItem(cashOrderItem: ProductOrderItem(product: product, cupSize: 3))
        dismiss(animated: true, completion: nil)
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
