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
    
    @IBOutlet weak var cardTextBtn: UIButton!
    @IBOutlet weak var paymentValue: UILabel!
    @IBOutlet weak var maxPaymentBtn: UIButton!
    @IBOutlet weak var restLbl: UILabel!
    
    
    var isCashSelected = false
    var isReselected = false
    var maxValue: Int!
    var success: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        
        maxPaymentBtn.setTitle(String(maxValue), for: UIControlState.normal)
        paymentValue.text = String(maxValue).getSignedStr()
    }
    
    func setData(price: Int, success: @escaping () -> ()){
        self.maxValue = price
        self.success = success
    }
    
    func style() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setRest(allPayment: Int){
        if allPayment > maxValue{
            restLbl.isHidden = false
            restLbl.text = String(allPayment - maxValue).getSignedStr()
        } else {
            restLbl.isHidden = true
        }
    }
    
    @IBAction func changeLanguage(sender: UIButton) {
        if isCashSelected{
            var curValue = cashTextBtn.currentTitle == nil || cashTextBtn.currentTitle!.isEmpty ? "0" : cashTextBtn.currentTitle!
            
            if isReselected{
                curValue = sender.currentTitle!
            } else{
                if curValue == "0"{
                    curValue = sender.currentTitle!
                } else{
                    curValue += sender.currentTitle!
                }
            }
            
            let otherValue = maxValue - Int(curValue)! > 0 ? maxValue - Int(curValue)! : 0
            cashTextBtn.setTitle(String(Int(curValue)!), for: UIControlState.normal)
            cardTextBtn.setTitle(String(otherValue), for: UIControlState.normal)
            
            setRest(allPayment: Int(curValue)! + otherValue)
        } else {
            var curValue = cardTextBtn.currentTitle == nil || cardTextBtn.currentTitle!.isEmpty ? "0" : cardTextBtn.currentTitle!
            
            if isReselected{
                curValue = sender.currentTitle!
            } else{
                if curValue == "0"{
                    curValue = sender.currentTitle!
                } else{
                    curValue += sender.currentTitle!
                }
            }
            
            let otherValue = maxValue - Int(curValue)! > 0 ? maxValue - Int(curValue)! : 0
            cardTextBtn.setTitle(String(Int(curValue)!), for: UIControlState.normal)
            cashTextBtn.setTitle(String(otherValue), for: UIControlState.normal)
            
            setRest(allPayment: Int(curValue)! + otherValue)
        }
    
        isReselected = false
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        if isCashSelected{
            var curValue = cashTextBtn.currentTitle == nil || cashTextBtn.currentTitle!.isEmpty ? "0" : cashTextBtn.currentTitle!
            
            if curValue.count > 1{
                curValue = String(curValue.dropLast())
            } else{
                curValue = "0"
            }
            
            let otherValue = maxValue - Int(curValue)! > 0 ? maxValue - Int(curValue)! : 0
            
            cashTextBtn.setTitle(String(Int(curValue)!), for: UIControlState.normal)
            cardTextBtn.setTitle(String(otherValue), for: UIControlState.normal)
            setRest(allPayment: Int(curValue)! + otherValue)
        } else {
            var curValue = cardTextBtn.currentTitle == nil || cardTextBtn.currentTitle!.isEmpty ? "0" : cardTextBtn.currentTitle!
            
            if curValue.count > 1{
                curValue = String(curValue.dropLast())
            } else{
                curValue = "0"
            }
            
            let otherValue = maxValue - Int(curValue)! > 0 ? maxValue - Int(curValue)! : 0
            
            cardTextBtn.setTitle(String(Int(curValue)!), for: UIControlState.normal)
            cashTextBtn.setTitle(String(otherValue), for: UIControlState.normal)
            setRest(allPayment: Int(curValue)! + otherValue)
        }
    }
    
    @IBAction func cashTextBtn(_ sender: Any) {
        
        cashTextBtn.borderColorV = UIColor.init(red: 1, green: 120/255, blue: 0, alpha: 1)
        cardTextBtn.borderColorV = UIColor.init(white: 0.67, alpha: 1)
        isCashSelected = true
        isReselected = true
        
    }
    @IBAction func cardTextByn(_ sender: Any) {
        
        cashTextBtn.borderColorV = UIColor.init(white: 0.67, alpha: 1)
        cardTextBtn.borderColorV = UIColor.init(red: 1, green: 120/255, blue: 0, alpha: 1)
        isCashSelected = false
        isReselected = true
        
    }
    @IBAction func cancelBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
