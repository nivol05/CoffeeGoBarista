//
//  EditElementVC.swift
//  CofeeGo
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class EditElementVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var elementCountLbl: UILabel!
    @IBOutlet weak var otherPercentTF: UITextField!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemCupLbl: UILabel!
    @IBOutlet weak var itemSinglePriceLbl: UILabel!
    @IBOutlet weak var itemDiscountLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    
    @IBOutlet weak var percentsOne: UIButton!
    @IBOutlet weak var percentsTwo: UIButton!
    @IBOutlet weak var percentsThree: UIButton!
    @IBOutlet weak var percentsFour: UIButton!
    
    
    var cashBoxVC: MainCashBoxVC!
    var orderItem: CashOrderItem!
    var listPos: Int!
    var discountList: [Discount]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        otherPercentTF.delegate = self
        
        otherPercentTF.addTarget(self, action: #selector(percentsChangedText), for: .editingChanged)
        
        setPercents()
        setData()
    }
    
    private func setData(){
        elementCountLbl.text = String(orderItem.count)
        itemDiscountLbl.text = String(orderItem.getDiscountValue()).getSignedStr()
        itemSinglePriceLbl.text = String(orderItem.getSinglePrice()).getSignedStr()
        itemCupLbl.text = orderItem.getCup()
        otherPercentTF.text = orderItem.discount == 0 ? "" : String(orderItem.discount)
        itemPriceLbl.text = String(orderItem.getDiscount()).getSignedStr()
    }
    
    private func setPercents(){
        
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

    @objc func percentsChangedText(){
        var value = otherPercentTF.text == nil || otherPercentTF.text!.isEmpty ? 0 : Int(otherPercentTF.text!)!
        
        if (value > 100){
            value = 100
            otherPercentTF.text = "100"
        }
        
        orderItem.setDiscount(value: value)
        
        itemDiscountLbl.text = String(orderItem.getDiscountValue()).getSignedStr()
        
        itemPriceLbl.text = String(orderItem.getDiscount()).getSignedStr()
    }

    @IBAction func confirmBtn(_ sender: Any) {
        cashBoxVC.changeOrderItem(pos: listPos, cashOrderItem: orderItem)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addElement(_ sender: Any) {
        orderItem.increase()
        elementCountLbl.text = String(orderItem.count)
        
        itemDiscountLbl.text = String(orderItem.getDiscountValue()).getSignedStr()
        
        itemPriceLbl.text = String(orderItem.getDiscount()).getSignedStr()
    }
    
    @IBAction func removeElement(_ sender: Any) {
        orderItem.decrease()
        elementCountLbl.text = String(orderItem.count)
        
        itemDiscountLbl.text = String(orderItem.getDiscountValue()).getSignedStr()
        
        itemPriceLbl.text = String(orderItem.getDiscount()).getSignedStr()
    }
    @IBAction func deleteElement(_ sender: Any) {
        cashBoxVC.removeItem(pos: listPos)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectPercent(sender: UIButton){
        //        "\(sender.titleLabel!.text!)"
        //        cashText.remove(at: cashText.index(before: cashText.endIndex))
        
        let percent = "\(sender.titleLabel!.text!)"
        let percentValue = String(percent.dropLast(2))
        otherPercentTF.text = percentValue
        orderItem.setDiscount(value: Int(percentValue)!)
        
        itemDiscountLbl.text = String(orderItem.getDiscountValue()).getSignedStr()
        
        itemPriceLbl.text = String(orderItem.getDiscount()).getSignedStr()
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
