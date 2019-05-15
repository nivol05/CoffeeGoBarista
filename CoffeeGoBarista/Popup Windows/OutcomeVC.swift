//
//  OutcomeVC.swift
//  CofeeGo
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class OutcomeVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var reasonCostTF: UITextView!
    @IBOutlet weak var priceCostTF: UITextField!
    @IBOutlet weak var reasonCostLbl: UILabel!
    @IBOutlet weak var priceCostLbl: UILabel!
    
    var priceCostText = "Цена затраты:"
    var reasonCostText = "Причина затраты:"
    
    var incomeElem: IncomeElem? = nil
    var finishFunc: (() -> ()?)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interface()
    }
    
    func interface(){
        priceCostTF.delegate = self
        priceCostTF.text = "0"
        priceCostLbl.text = priceCostText
        reasonCostLbl.text = reasonCostText
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        let text = textField.text != nil ? textField.text! : ""
        let newLength = text.count + string.count - range.length
        
        if string != numberFiltered{
            view.makeToast("В этом поле могут быть введены только цыфры")
        }
        
        if textField.text == "0"{
            textField.text = ""
        }
        
        return string == numberFiltered && newLength <= 6
    }
    
//    func finishIncome(){
//        let incSize = db.getIncomes().count
//        print("Inv \(incSize)")
//        let incomeElem = IncomeElem.init(
//            id: incSize + 1,
//            spot: getSpotId(),
//            value: StringUtils.toJsonString(elems: inventoryData),
//            date: getCurrentDate(),
//            time: getTimeNow())
//        db.setIncomes(x: incomeElem)
//        print(db.setIncomes(x: incomeElem))
//    }
    
    //Privates
    private func getOutcome(price: Int, reason: String) -> OutcomeElem{
        if (incomeElem != nil){
            return getOutcomeWithIncome(price: price, reason: reason)
        }
        
        let size = db.getOutcomes().count
        return OutcomeElem(id: size + 1,
                           spot: getSpotId(),
                           income: nil,
                           price: price,
                           date: getCurrentDate(),
                           reason: reason,
                           time: getTimeNow())
        
        
    }
    
    private func getOutcomeWithIncome(price: Int, reason: String) -> OutcomeElem{
        let size = db.getOutcomes().count
        return OutcomeElem(id: size + 1,
                           spot: getSpotId(),
                           income: incomeElem!.id,
                           price: price,
                           date: getCurrentDate(),
                           reason: reason,
                           time: getTimeNow())
        
        
    }
    
    private func saveOutcome(outcome: OutcomeElem){
        if (finishFunc != nil){
            finishFunc!()
        }
        db.setOutcome(x: outcome)
    }
    
    private func finishView(){
        if incomeElem != nil{
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "Bar")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = redViewController
            incomeElem = nil
            finishFunc = nil
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func isReasonValid() -> Bool{
        return !reasonCostTF.text.isEmpty
    }
    
    private func isPriceValid() -> Bool{
        if (priceCostTF.text == nil){
            return false
        }
        return !priceCostTF.text!.isEmpty
    }
    
    //Actions
    @IBAction func cancelBtn(_ sender: Any) {
        finishView()
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        if (isReasonValid() && isPriceValid()){
            saveOutcome(outcome: getOutcome(price: Int(priceCostTF.text!) ?? 0,
                                            reason: reasonCostTF.text))
            finishView()
            
        } else {
            self.view.makeToast("Не все поля заполнены")
        }
    }
    
    @IBAction func priceCostEndEditing(_ sender: Any) {
        if priceCostTF.text?.count == 0{
            priceCostTF.text = "0"
        }
    }
    
}
