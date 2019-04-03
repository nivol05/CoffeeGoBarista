//
//  OrderItemsVC.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 04.09.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Toast_Swift
import NVActivityIndicatorView
import PopupDialog

class OrderItemsVC: UIViewController, UITableViewDelegate,UITableViewDataSource, NVActivityIndicatorViewable {

    @IBOutlet weak var commentBG: UIView!
    @IBOutlet weak var cancelOrderBtn: UIButton!
    
    @IBOutlet weak var CurrTime: UITextField!
    @IBOutlet weak var TFTime: UITextField!
    @IBOutlet weak var TFPrice: UITextField!
    @IBOutlet weak var takeawayTF : UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var CommentLbl: UITextView!
    
    //COW - cancel order window
    @IBOutlet weak var COW: UIView!
    @IBOutlet weak var bgCOWView: UIView!
    @IBOutlet weak var confirmCOWBtn: UIButton!
    @IBOutlet weak var cancelCOWBtn: UIButton!
    @IBOutlet weak var reasonCOWTF: UITextView!
    
    var COWsender: UIButton!

    static var checkTimer = true
    
    var time = 0
    var timer = Timer()
    
    var Id : Int!
    
    var orderItems : [ElementOrderItem]!
    var order : ElementOrder!
    
    var menu: [ElementProduct]!
    var syrups: [SyrupElem]!
    var additionals: [AdditionalElem]!
    
    let statuses = [
        "",
        "Подтвердить",
        "Завершить",
        "Завершено",
        "Отклонено клиентом",
        "Завершить приготовление",
        "Отклонено заведением",
        "Завершить заказ"]
    
    let statusColors = [
        nil,
        UIColor(red: 1, green: 179/255, blue: 0, alpha: 1),
        UIColor(red: 50/255, green: 215/255, blue: 75/255, alpha: 1),
        UIColor(red: 50/255, green: 215/255, blue: 75/255, alpha: 1),
        nil,
        nil,
        nil,
        nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu = db.getProducts()
        syrups = db.getSyrups()
        additionals = db.getAdds()
        
        style()
//        performSegue(withIdentifier: "goToMain", sender: nil)
//        dismiss(animated: true, completion: nil)
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        cornerRatio(view: commentBG, ratio: 5, masksToBounds: true)
        statusBtn.layer.cornerRadius = statusBtn.frame.height/2
        CommentLbl.layer.cornerRadius = 5
        cornerRatio(view: cancelOrderBtn, ratio: cancelOrderBtn.frame.height/2, masksToBounds: false)
//        if OrderItemsVC.checkTimer{
            timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(OrderItemsVC.Time), userInfo: nil, repeats: true)
//            OrderItemsVC.checkTimer = false
//        }
        
        textField(TF: TFPrice)
        textField(TF: TFTime)
        textField(TF: CurrTime)
        textField(TF: takeawayTF)
        
        getOrder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    func style(){
        cornerRatio(view: cancelCOWBtn, ratio: 5, masksToBounds: false)
        cornerRatio(view: confirmCOWBtn, ratio: 5, masksToBounds: false)
        cornerRatio(view: bgCOWView, ratio: 5, masksToBounds: false)
        cornerRatio(view: reasonCOWTF, ratio: 5, masksToBounds: false)
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    func setStatusView(){
//        self.checkOrder(order: self.order, status: self.order.status)
        statusBtn.setTitle(self.statuses[order.status], for: UIControl.State())
        statusBtn.layer.backgroundColor = self.statusColors[order.status]?.cgColor
    }
    
    func textField(TF : UITextField){
        
        TF.layer.cornerRadius = 15
        TF.layer.masksToBounds = true
        TF.layer.borderColor = UIColor(white: 0.88, alpha: 1).cgColor
        TF.layer.borderWidth = 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderItems == nil{
            return 0
        }
        return orderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItems", for: indexPath) as? OrderItems
        
        let orderItem = orderItems[indexPath.row]
        let product_id = orderItem.product
        var element : ElementProduct!
        for i in menu{
            if product_id == i.id{
                element = i
                break
            }
        }
        
        //CoffeeImag
        if element.img != nil{
            cell?.ImgCoffee.kf.setImage(with: URL(string: element.img!)!)
        } else{
            cell?.ImgCoffee.image = #imageLiteral(resourceName: "coffee-cup")
        }
        
        cell?.LblName.text = element.name
        
        
        var coffee_price = ""
        switch "\(orderItem.cup_size!)"{
            
        case "l":
            coffee_price += "\(element.l_cup!)"
            break
        case "m":
            coffee_price +=  "\(element.m_cup!)"
            break
        case "b":
            coffee_price += "\(element.b_cup!)"
            break
        default:
            coffee_price += "\(element.price!)"
        }
        coffee_price += " грн"
        cell?.LblPrice.text = coffee_price
        //            " " + context.getString(R.string.grn)
        
        let sugar = orderItem.sugar
        let species = "\(orderItem.species!)"
        
        
        //        cell?.LbllAdditions.text = ("\(ordersElements["additionals"]!)")
        
        if orderItem.syrups != nil && orderItem.syrups != ""{ // Making syrups string
            let syrupsInStr = orderItem.syrups.components(separatedBy: ", ")
            var syrupsText = "Сиропы: "
            for i in 0..<syrupsInStr.count{
                let value = syrupsInStr[i]
                
                for x in syrups{
                    if value == x.name{
                        syrupsText.append(x.name)
                        syrupsText.append("( +\(x.price) грн)")
                        break
                    }
                }
                
                
                if i != syrupsInStr.count - 1{
                    syrupsText.append(", ")
                }
            }
            cell?.LblSyrup.text = syrupsText
        } else {
            cell?.LblSyrup.text = ""
        }
        
        if orderItem.additionals != nil && orderItem.additionals != ""{ // Making adds string
            let addsInStr = orderItem.additionals.components(separatedBy: ", ")
            var addsText = "Добавки: "
            for i in 0..<addsInStr.count{
                let value = addsInStr[i]
                
                for x in additionals{
                    if value == x.name{
                        addsText.append(x.name)
                        addsText.append("( +\(x.price) грн)")
                        break
                    }
                }
                
                
                if i != addsInStr.count - 1{
                    addsText.append(", ")
                }
            }
            cell?.LbllAdditions.text = addsText
        } else {
            cell?.LbllAdditions.text = ""
        }
        
        if species != ""{
            cell?.LblSpice.text = "Специи: \(species)"
        } else {
            cell?.LblSpice.text = ""
        }
        
        if sugar != 0.0 {
            cell?.LblSugar.text = "Сахар: \(sugar!)"
        } else {
            cell?.LblSugar.text = ""
        }
        //        cell?.LblSugar.text = "Сахар: \(sugar!)"
        
        cell?.LblUltPrice.text = "Всего: \((orderItem.item_price + orderItem.additionals_price)) грн"
        
        
        return cell!
    }
    
    func getOrder(){
        
        getOrderById(orderId: Id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.order = ElementOrder(mas: value as! [String : Any])
                if self.order.takeaway{
                    self.takeawayTF.text = "C собой"
                } else{
                    self.takeawayTF.text = "На месте"
                }
                
                self.TFPrice.text = "\(self.order.full_price!) грн"
                self.TFTime.text = self.order.order_time
                
                if self.order.comment == ""{
                    self.CommentLbl.text = "Нету комментария"
                } else {
                    self.CommentLbl.text = self.order.comment!
                }
                
                let currMins = toMins(time: getTimeNow())
                let mins = toMins(time: self.order.order_time)
                
                var minsToOrder = mins - currMins
                
                if !isToday(date: self.order.date!){
                    if isBeforeToday(date: self.order.date){
                        self.CurrTime.text = self.order.date!
                    } else {
                        if minsToOrder < 0 {
                            minsToOrder += 1440 // 1440 mins in 24 hrs
                        }
                        self.CurrTime.text = "Через \(minsToOrder) минут"
                    }
                } else {
                    self.CurrTime.text = "Через \(minsToOrder) минут"
                }
                
                if  self.order.status == 1{
                    self.cancelOrderBtn.isHidden = false
                } else {
                    self.cancelOrderBtn.isHidden = true
                }
                
                self.getOrderItems()
                break
            case .failure(let error):
                                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                                self.stopAnimating()
                print(error)
                break
            }
        }
    }

    
    func getOrderItems(){
        getOrderItemsToOrder(orderId: Id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.orderItems = setElementList(list: value as! [[String : Any]])
            
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.setStatusView()
                self.stopAnimating()
                break
            case .failure(let error):
                                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    
    @objc func Time()
    {
        print("TYT2")
//        let currMins = toMins(time: getTimeNow())
        let mins = toMins(time: self.order.order_time)

        var minsToOrder = mins - toMins(time: getTimeNow())
        if !isToday(date: order.date!){
            if isBeforeToday(date: order.date){
                self.CurrTime.text = order.date!
            } else {
                if minsToOrder < 0 {
                    minsToOrder += 1440 // 1440 mins in 24 hrs
                }
                self.CurrTime.text = "Через \(minsToOrder) минут"
            }
        } else {
            self.CurrTime.text = "Через \(minsToOrder) минут"
        }
    }
    
    func btnStatusClick(){
        if order.status == 1{
            checkOrder(order: order, status: 2)
        } else if order.status == 2{
            checkOrder(order: order, status: 3)
        }
//        else if order.status == 5{
//            checkOrder(order: order, status: 3)
//        } else if order.status == 7{
//            checkOrder(order: order, status: 3)
//        }
        
    }
    
    func checkOrder(order : ElementOrder, status : Int){
        getOrderById(orderId: order.id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let orderResponse = ElementOrder(mas: value as! [String : Any])
                if orderResponse.status != 4{
                    print("tyta ya")
                    order.status = status
                    self.putNewOrder(order: order, status: status)
                    
                } else {
                    self.view.makeToast("Заказ уже был отменен пользователем")
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "Bar")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = redViewController
//                    TEST IT
//                    navigationController?.popViewController(animated: true)
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func putNewOrder(order : ElementOrder, status : Int){
        
        if order.status == 6{
            order.canceled_barista_message = reasonCOWTF.text!
        }
        
        patchOrder(order: order).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.setStatusView()
                OrderVC.isChangingStatus = true
                self.order = order
                if order.status == 3 || order.status == 6{
                    self.COW.isHidden = true
                    self.reasonCOWTF.text = ""
                    updateCashBoxList = true
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "Bar")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = redViewController
//                    
                } else {
                    self.cancelOrderBtn.isHidden = true
                }
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func showStandardDialog(animated: Bool = true ) {
        
        // Prepare the popup
        let title = ""
        let message = "Вы уверены, что хотите отменить заказ?"
        
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: true,
                                hideStatusBar: true) {
                                    print("Completed")
        }
        
        // Create first button
        let buttonOne = CancelButton(title: "Нет") {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Да") {
            self.checkOrder(order: self.order, status: 6)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    @IBAction func confirmCOWBtn(_ sender: Any) {
        self.checkOrder(order: self.order, status: 6)
    }
    
    @IBAction func cancelCOWBtn(_ sender: Any) {
        //        COW.isHidden = true
        fadeView(view: COW, delay: 0, isHiden: true)
        self.reasonCOWTF.text = ""
    }
    
    @IBAction func statusBtn(_ sender: Any) {
        btnStatusClick()
    }
    @IBAction func cancelOrderBtn(_ sender: Any) {
        COW.isHidden = false
        fadeView(view: COW, delay: 0, isHiden: false)
//        COWsender = sender
    }
}
