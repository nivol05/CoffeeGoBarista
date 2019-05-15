//
//  ConfirmOrderVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 2/22/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView

class ConfirmOrderVC: UIViewController, NVActivityIndicatorViewable {
    
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
    var orderItems: [CashOrderItem]!
    var listDiscount: Int!
    
    var order: ElementOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    
    func setData(price: Int, list: [CashOrderItem], success: @escaping () -> ()){
        self.maxValue = price
        self.success = success
        self.orderItems = list
    }
    
    func setOnlineData(order: ElementOrder, maxValue: Int, success: @escaping () -> ()){
        self.maxValue = maxValue
        self.order = order
        self.success = success
    }
    
    func style() {
        cashTextBtn.setTitle("0", for: UIControlState.normal)
        cardTextBtn.setTitle("0", for: UIControlState.normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        cashTextBtn(cashTextBtn)
        maxPaymentBtn.setTitle(String(maxValue), for: UIControlState.normal)
        cashTextBtn.setTitle(String(maxValue), for: UIControlState.normal)
        paymentValue.text = String(maxValue).getSignedStr()
        setRest(allPayment: maxValue)
    }
    
    func setRest(allPayment: Int){
        if allPayment > maxValue{
            restLbl.isHidden = false
            restLbl.text = "Сдача: \(String(allPayment - maxValue).getSignedStr())"
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
                    if (curValue.count <= 5){
                        curValue += sender.currentTitle!
                    }
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
                    if (curValue.count <= 5){
                        curValue += sender.currentTitle!
                    }
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
    
    private func saveOrder(cash: Int, card: Int){
        let user = db.getUser()!
        var order = OrderOffline()
        let ordersCount = db.getOrdersOffline().count
        order.id = ordersCount + 1
        order.user = user.id
        order.username = user.username
        order.coffee_spot = getSpotId()
        order.full_price = self.maxValue
        order.date = getCurrentDate()
        order.order_time = getTimeNow()
        order.status = 3
        order.cash_payment = cash
        order.card_payment = card
        order.discount = getListDiscount()
        order.is_posted = false
        order.list_pos = ordersCount + 1
        
        
        db.setOrderOffline(x: order)
        saveOrderItems(id: order.id)
    }
    
    private func saveOrderItems(id: Int){
        var items = [OrderItemOfflineElem]()
        var itemsSize = db.getItemsOffline().count
        for item in orderItems{
            var cup = ""
            switch item.cupSize{
            case 1:
                cup = "l"
                break
            case 2:
                cup = "m"
                break
            case 3:
                cup = "b"
                break
            default:
                cup = "default"
                break
            }
            let orderItem = OrderItemOfflineElem(
                id: itemsSize + 1,
                order: id,
                product: item.product?.id,
                syrups: item.syrup?.id,
                additionals: item.additional?.id,
                discount: item.discount,
                count: item.count,
                cup: cup,
                is_posted: false,
                time: getTimeNow())
            items.append(orderItem)
            
            itemsSize += 1
        }
        db.setItemsOffline(items: items)
        self.success()
        self.cancelBtn(self)
        print(items.count)
    }
    
    private func getListDiscount() -> Int{
        let res = orderItems[0].discount
        for item in orderItems{
            if res != item.discount{
                return 0
            }
        }
        return res
    }
    
    private func patchOrder(){
        self.startAnimating()
        order?.status = 3
        CoffeeGoBarista.patchOrder(order: self.order!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                db.setOrderOnline(x: self.order!)
                self.stopAnimating()
                self.cancelBtn(self)
                self.success()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
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
    @IBAction func maxValueBTn(_ sender: Any) {
        if isCashSelected{
            cashTextBtn.setTitle(String(maxValue), for: UIControlState.normal)
            cardTextBtn.setTitle(String(0), for: UIControlState.normal)
            setRest(allPayment: maxValue)
        } else {
            cashTextBtn.setTitle(String(0), for: UIControlState.normal)
            cardTextBtn.setTitle(String(maxValue), for: UIControlState.normal)
            setRest(allPayment: maxValue)
        }
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        let cash = Int(cashTextBtn.currentTitle!)! <= maxValue ? Int(cashTextBtn.currentTitle!) : maxValue
        let card = Int(cardTextBtn.currentTitle!)! <= maxValue ? Int(cardTextBtn.currentTitle!) : maxValue
        if (order != nil){
            order?.cash_payment = cash
            order?.card_payment = card
            patchOrder()
        } else {
            saveOrder(cash: cash!, card: card!)
        }
    }
    @IBAction func cancelBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
