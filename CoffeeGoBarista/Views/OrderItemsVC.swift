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
    let date = NSDate()
    let calendar = NSCalendar.current
    let currMin = NSCalendar.current.component(.hour, from: NSDate() as Date) * 60 + NSCalendar.current.component(.minute, from: NSDate() as Date)
    
    var Id : Int!
    
    var orderItems : [[String: Any]] = [[String: Any]]()
    var order : [String : Any] = [String : Any]()
    
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
        
//        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(OrderItemsVC.Time), userInfo: nil, repeats: true)
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
        return orderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItems", for: indexPath) as? OrderItems
        
        let ordersElements = orderItems[indexPath.row]
        var avatar_url: URL
        let product_id = ordersElements["product"] as! Int
        var element : [String : Any] = [String: Any]()
        for i in staticData.menu{
            if product_id == i["id"] as! Int{
                element = i
                break
            }
        }
        
        avatar_url = URL(string: element["img"] as! String)!
        cell?.ImgCoffee.kf.setImage(with: avatar_url)
        
        cell?.LblName.text = element["name"] as? String
        
        
        var coffee_price = ""
        switch "\(ordersElements["cup_size"]!)"{
            
        case "l":
            coffee_price += "\(element["l_cup"]!)"
            break
        case "m":
            coffee_price +=  "\(element["m_cup"]!)"
            break
        case "b":
            coffee_price += "\(element["b_cup"]!)"
            break
        default:
            coffee_price += "\(element["price"]!)"
        }
        coffee_price += " grn"
        cell?.LblPrice.text = coffee_price
        
        let sugar = ordersElements["sugar"] as? Double
        let syrup = "\(ordersElements["syrups"]!)"
        let species = "\(ordersElements["species"]!)"
        let additions = ("\(ordersElements["additionals"]!)")
        
        
        if additions != "" && additions != "<null>" {
            cell?.LbllAdditions.text = "Додатки: \(additions)"
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
        
        if syrup != ""{
            cell?.LblSyrup.text = "Сиропи: \(syrup)"
        } else {
            cell?.LblSyrup.text = ""
        }
        
        cell?.LblUltPrice.text = "Всего: \(ordersElements["item_price"]!)грн"
        
        return cell!
    }
    
    func getOrder(){
        let isUser = "\(BASE_URL)\(Orders)\(Id!)/"
        print(isUser)
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            self.order = response.result.value as! [String : Any]
            self.statusBtn.setTitle("\(self.statuses[self.order["status"] as! Int])", for: UIControlState())
            self.TFPrice.text = "\(self.order["full_price"]!) грн"
            //                self.CurrTime.text = self.order["date"] as? String
            self.TFTime.text = self.order["order_time"] as? String
            
            
            
            
            let mins = self.toMins(s: self.order["order_time"] as! String)
            
            var minsToOrder = mins - self.currMin
            if minsToOrder < 0{
                minsToOrder += 1440
            }
            
            self.CurrTime.text = "Через \(minsToOrder) минут"
            
            self.getOrdersItem()
        }
    }
    
    func toMins(s : String) -> Int{
        var hourMin = s.components(separatedBy: " : ")
        let hour = Int(hourMin[0])
        let mins = Int(hourMin[1])
        return hour! * 60 + mins!
    }

    
    func getOrdersItem(){
        let isUser = "\(BASE_URL)\(Order_Items)\(Id!)"
        print(isUser)
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            self.orderItems = response.result.value as! [[String : Any]]
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            
        }
    }
    @IBAction func statusBtn(_ sender: Any) {
        btnStatusClick()
    }
    
//    @objc func Time()
//    {
//        let mins = self.toMins(s: self.order["order_time"] as! String)
//        print("Tyt2")
//        var minsToOrder = mins - self.currMin
//        if minsToOrder < 0{
//            minsToOrder += 1440
//        }
//
//        self.CurrTime.text = "Через \(minsToOrder) минут"
//    }
    
    func btnStatusClick(){
        var Order = order
        let status = Order["status"] as! Int
        if status == 1{
            Order["status"] = 2
            putNewOrder(order: Order)
        } else if status == 2{
            Order["status"] = 5
            putNewOrder(order: Order)
        }else if status == 5{
            Order["status"] = 7
            putNewOrder(order: Order)
        } else if status == 7{
            //            startQuestion();
        }
        
    }
    
    func putNewOrder(order : [String: Any]){
        let isUser = "\(BASE_URL)\(Orders)\(order["id"]!)/"
        print(isUser)
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .put , parameters: order, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            if response.result.isSuccess {
                self.statusBtn.setTitle("\(self.statuses[order["status"] as! Int])", for: UIControlState())

                self.order = order
            } else {
                print("Hui")
            }
        }
    }
}
