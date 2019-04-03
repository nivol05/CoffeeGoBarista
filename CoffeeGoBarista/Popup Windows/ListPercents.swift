//
//  ListPercents.swift
//  CofeeGo
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class ListPercents: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var percentsOne: UIButton!
    @IBOutlet weak var percentsTwo: UIButton!
    @IBOutlet weak var percentsThree: UIButton!
    @IBOutlet weak var percentsFour: UIButton!
    @IBOutlet weak var otherPercentTF: UITextField!
    var cashBoxVC: MainCashBoxVC!
    var discountList : [Discount]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        otherPercentTF.delegate = self
        otherPercentTF.addTarget(self, action: #selector(textChange), for: .editingChanged)
        
        setPercents()
        // Do any additional setup after loading the view.
    }
    
    func setPercents(){
        
        otherPercentTF.text = ""
        
        if(discountList.isEmpty){
            percentsOne.setTitle("10 %", for: UIControlState.normal)
            percentsTwo.setTitle("100 %", for: UIControlState.normal)
            percentsTwo.isHidden = false
            percentsThree.isHidden = true
            percentsFour.isHidden = true
        } else{
            if (discountList.count >= 1){
                percentsOne.setTitle("\(discountList[0].discount_value) %", for: UIControlState.normal)
            }
            if (discountList.count >= 2){
                percentsTwo.setTitle("\(discountList[1].discount_value) %", for: UIControlState.normal)
                percentsTwo.isHidden = false
            }else{
                percentsTwo.isHidden = true
            }
            if (discountList.count >= 3){
                percentsThree.setTitle("\(discountList[2].discount_value) %", for: UIControlState.normal)
                percentsThree.isHidden = false
            }else{
                percentsThree.isHidden = true
            }
            if (discountList.count >= 4){
                percentsFour.setTitle("\(discountList[3].discount_value) %", for: UIControlState.normal)
                percentsFour.isHidden = false
            }else{
                percentsFour.isHidden = true
            }
        }
    }

    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        if (!otherPercentTF.text!.isEmpty){
            cashBoxVC.setPercentsList(discount: Int(otherPercentTF.text!)!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPercent(sender: UIButton){
//        "\(sender.titleLabel!.text!)"
//        cashText.remove(at: cashText.index(before: cashText.endIndex))
        
        let percent = "\(sender.titleLabel!.text!)"
        let percentValue = String(percent.dropLast(2))
        otherPercentTF.text = percentValue
    }
    
    @objc func textChange(){
        var value = otherPercentTF.text == nil || otherPercentTF.text!.isEmpty ? 0 : Int(otherPercentTF.text!)!
        
        if (value > 100){
            value = 100
            otherPercentTF.text = "100"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        let text = textField.text != nil ? textField.text! : ""
        let newLength = text.count + string.count - range.length
        
        return string == numberFiltered && newLength <= 3
    }

}
