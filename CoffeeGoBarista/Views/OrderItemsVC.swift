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

class OrderItemsVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var CurrTime: UITextField!
    @IBOutlet weak var TFTime: UITextField!
    @IBOutlet weak var TFPrice: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var CommentLbl: UITextView!

    var time = 0
    var timer = Timer()
    
    var Id : Int!
    
    var orderItems : [ElementOrderItem]!
    var order : ElementOrder!
    
    let statuses = [
        "",
        "Підтвердити",
        "Виконую",
        "Виконано",
        "Відхилено клієнтом",
        "Завершити приготування",
        "Відхилено закладом",
        "Завершити замовлення"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBtn.layer.cornerRadius = 5
        CommentLbl.layer.cornerRadius = 5
        
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(OrderItemsVC.Time), userInfo: nil, repeats: true)
        
        textField(TF: TFPrice)
        textField(TF: TFTime)
        textField(TF: CurrTime)
        
        getOrder()
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
            cell?.ImgCoffee.kf.setImage(with: URL(string: element.img)!)
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
        let syrup = "\(orderItem.syrups!)"
        let species = "\(orderItem.species!)"
        let additions = ("\(orderItem.additionals!)")
        
        
        //        cell?.LbllAdditions.text = ("\(ordersElements["additionals"]!)")
        
        if additions != "" && additions != "<null>" {
            cell?.LbllAdditions.text = "Добавки: \(additions)"
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
            cell?.LblSpice.text = ""
        }
        //        cell?.LblSugar.text = "Сахар: \(sugar!)"
        
        if syrup != ""{
            cell?.LblSyrup.text = "Сиропы: \(syrup)"
        } else {
            cell?.LblSyrup.text = ""
        }
        
        cell?.LblUltPrice.text = "Всего: \((orderItem.item_price + orderItem.additionals_price)) грн"
        
        return cell!
    }
    
    func getOrder(){
        
        getOrderById(orderId: Id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.order = ElementOrder(mas: value as! [String : Any])
                self.TFPrice.text = "\(self.order.full_price!) грн"
                self.TFTime.text = self.order.order_time
                
                
                let currMins = toMins(time: getTimeNow())
                let mins = toMins(time: self.order.order_time)
                
                var minsToOrder = mins - currMins
                if minsToOrder < 0{
                    minsToOrder += 1440
                }
                
                self.CurrTime.text = "Через \(minsToOrder) минут"
                
                self.getOrderItems()
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
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
                self.orderItems = setElementOrderItemList(list: value as! [[String : Any]])
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    @IBAction func statusBtn(_ sender: Any) {
        btnStatusClick()
    }
    
    @objc func Time()
    {
        let currMins = toMins(time: getTimeNow())
        let mins = toMins(time: self.order.order_time)
        
        var minsToOrder = mins - currMins
        if minsToOrder < 0{
            minsToOrder += 1440
        }
        self.CurrTime.text = "Через \(minsToOrder) минут"
    }
    
    func btnStatusClick(){
        if order.status == 1{
            checkOrder(order: order, status: 2)
        } else if order.status == 2{
            checkOrder(order: order, status: 5)
        }else if order.status == 5{
            checkOrder(order: order, status: 7)
        } else if order.status == 7{
            checkOrder(order: order, status: 3)
        }
        
    }
    
    func checkOrder(order : ElementOrder, status : Int){
        getOrderById(orderId: order.id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let orderResponse = ElementOrder(mas: value as! [String : Any])
                if orderResponse.status != 4{
                    order.status = status
                    self.putNewOrder(order: order, status: status)
                } else {
//                    self.view.makeToast("Заказ уже был отменен пользователем")
                    self.dismiss(animated: true, completion: nil)
                }
                break
            case .failure(let error):
//                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
//                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func putNewOrder(order : ElementOrder, status : Int){
        patchOrder(order: order).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.statusBtn.setTitle("\(self.statuses[order.status])", for: UIControl.State())
                OrderVC.isChangingStatus = true
                self.order = order
                if order.status == 3{
                    self.dismiss(animated: true, completion: nil)
                }
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
        }
    }
}
