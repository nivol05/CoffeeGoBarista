//
//  OrderVC.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 30.06.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrderVC: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {

    @IBOutlet weak var collection: UICollectionView!
    
    static var isChangingStatus : Bool!
    var orders : [[String: Any]] = [[String: Any]]()
    
    var time = 0
    
    var timer = Timer()
    
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
        OrderVC.isChangingStatus = true
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(OrderVC.sayHello), userInfo: nil, repeats: true)
        self.collection.dataSource = self
        self.collection.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        if OrderVC.isChangingStatus{
            getOrders()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let order = orders[indexPath.row]
        
        
        
        let price = "\(order["full_price"]!)"
        cell.LblPrice.text = "Сумма: \(price) грн"
        cell.LblTime.text = "Время: \(order["order_time"]!)"
        cell.orderIndex.text = "\(indexPath.row + 1)"
        cell.buttonBG.setTitle("\(self.statuses[order["status"] as! Int])", for: UIControlState())
        cell.buttonBG.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)

        let date = NSDate()
        let calendar = NSCalendar.current
        
        let currMin = calendar.component(.hour, from: date as Date) * 60 + calendar.component(.minute, from: date as Date)
       
        let mins = toMins(s: order["order_time"] as! String)
        
        var minsToOrder = mins - currMin
        if minsToOrder < 0{
            minsToOrder += 1440
        }
        
        cell.orderlbl.text = "Через \(minsToOrder) мин"
        
        cell.buttonBG.tag = indexPath.row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "OrderItemsPage") as! OrderItemsVC
        cell.Id = self.orders[indexPath.row]["id"] as! Int
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    @objc func sayHello()
    {
        print("Tyt")
        collection.reloadData()
    }
    
    func getOrders(){
        let isUser = "\(BASE_URL)\(List1_Order)\(staticData.spotId)"
        print(isUser)
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            if response.result.isSuccess {
                self.sortByTime(orders : response.result.value as! [[String : Any]])
                
                if OrderVC.isChangingStatus{
                    self.collection.reloadData()
                    OrderVC.isChangingStatus = false
                }
            } else {
                print("Hui")
            }
        }
    }
    
    func sortByTime(orders : [[String: Any]]){
        
        var sortedOrders : [[String: Any]] = [[String: Any]]()
        if orders.count == 0{
            self.orders = sortedOrders
            return
        }
        sortedOrders.append(orders[0])
        
        let date = NSDate()
        let calendar = NSCalendar.current
        
        let currMin = calendar.component(.hour, from: date as Date) * 60 + calendar.component(.minute, from: date as Date)
        
        for i in 1..<orders.count{
            let order = orders[i]
            var zl = true
            for j in 0..<sortedOrders.count{
                var mins = toMins(s: sortedOrders[j]["order_time"] as! String) - currMin
                var observMins = toMins(s: order["order_time"] as! String) - currMin
                
                if observMins < 0{
                    observMins = observMins + 1440
                }
                
                if mins < 0{
                    mins = mins + 1440
                }
                
                if observMins <= mins{
                    sortedOrders.insert(order, at: j)
                    zl = false
                    break;
                }
            }
            if zl{
                sortedOrders.append(order)
            }
            
            
            
        }
        
        self.orders = sortedOrders
        
    }
    
    func btnStatusClick(index : Int , sender:UIButton){
        var order = orders[index]
        let status = order["status"] as! Int
        if status == 1{
            order["status"] = 2
            putNewOrder(order: order, status: status, sender: sender)
        } else if status == 2{
            order["status"] = 5
            putNewOrder(order: order, status: status, sender: sender)
        }else if status == 5{
            order["status"] = 7
            putNewOrder(order: order, status: status, sender: sender)
        } else if status == 7{
            order["status"] = 3
            putNewOrder(order: order, status: status, sender: sender)
            
        }
    
    }
    
    func putNewOrder(order : [String: Any], status : Int , sender:UIButton){
        let isUser = "\(BASE_URL)\(Orders)\(order["id"]!)/"
        print(isUser)
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .put , parameters: order, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                sender.setTitle("\(self.statuses[order["status"] as! Int])", for: UIControlState())
                self.orders[sender.tag] = order
                if status == 7{
                    self.orders.remove(at: sender.tag)
                    self.collection.reloadData()
                }
            } else {
                print("Hui")
            }
            
        }
    }
    
    func toMins(s : String) -> Int{
        var hourMin = s.components(separatedBy: " : ")
        let hour = Int(hourMin[0])
        let mins = Int(hourMin[1])
        return hour! * 60 + mins!
    }
    
    @objc func cellOpened(sender:UIButton) {
        btnStatusClick(index: sender.tag, sender: sender)
    }
    
}
