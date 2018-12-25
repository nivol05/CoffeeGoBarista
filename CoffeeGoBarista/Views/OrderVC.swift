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
    var orders : [ElementOrder]!
    
    var time = 0
    
    var timer = Timer()
    
    let statuses = [
        "",
        "Подтвердить",
        "Готовлю",
        "Завершено",
        "Отклонено клиентом",
        "Завершить приготовление",
        "Отклонено заведением",
        "Завершить заказ"]
    
    let statusColors = [
        nil,
        UIColor.yellow,
        UIColor.yellow,
        UIColor.green,
        UIColor.red,
        UIColor.yellow,
        UIColor.red,
        UIColor.green]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderVC.isChangingStatus = true
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(OrderVC.sayHello), userInfo: nil, repeats: true)
        self.collection.dataSource = self
        self.collection.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getOrders()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if orders == nil{
            return 0
        }
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let order = orders[indexPath.row]
        
        cell.LblPrice.text = "Сумма: \(order.full_price!) грн"
        cell.LblTime.text = "Время: \(order.order_time!)"
        cell.orderIndex.text = "\(indexPath.row + 1)"
        cell.buttonBG.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
       
        self.setStatusView(btn: cell.buttonBG, status: order.status)
        let mins = toMins(time: order.order_time)
        
        var minsToOrder = mins - toMins(time: getTimeNow())
        if minsToOrder < 0 {
            minsToOrder += 1440 // 1440 mins in 24 hrs
        }
        
        cell.orderlbl.text = "Через \(minsToOrder) мин"
        
        cell.buttonBG.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "OrderItemsPage") as! OrderItemsVC
        cell.Id = self.orders[indexPath.row].id
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    @objc func sayHello()
    {
        print("Tyt")
        collection.reloadData()
    }
    
    func getOrders(){
        
        getOrdersListOne().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.sortByTime(orders : setElementOrderList(list: value as! [[String : Any]]))
                self.collection.reloadData()
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func sortByTime(orders : [ElementOrder]){
        
        var sortedOrders = [ElementOrder]()
        if orders.count == 0{
            self.orders = sortedOrders
            return
        }
        sortedOrders.append(orders[0])
        
        let currMin = toMins(time: getTimeNow())
        
        for i in 1..<orders.count{
            let order = orders[i]
            var higherMins = true
            for j in 0..<sortedOrders.count{
                var mins = toMins(time: sortedOrders[j].order_time) - currMin
                var observMins = toMins(time: order.order_time) - currMin
                
                if observMins < 0{
                    observMins = observMins + 1440
                }
                
                if mins < 0{
                    mins = mins + 1440
                }
                
                if observMins <= mins{
                    sortedOrders.insert(order, at: j)
                    higherMins = false
                    break;
                }
            }
            if higherMins{
                sortedOrders.append(order)
            }
        }
        self.orders = sortedOrders
    }
    
    func btnStatusClick(index : Int , sender:UIButton){
        let order = orders[index]
        if order.status == 1{
            checkOrder(order: order, status: 2, sender: sender)
        } else if order.status == 2{
            checkOrder(order: order, status: 5, sender: sender)
        }else if order.status == 5{
            checkOrder(order: order, status: 7, sender: sender)
        } else if order.status == 7{
            checkOrder(order: order, status: 3, sender: sender)
        }
    }
    
    func checkOrder(order : ElementOrder, status : Int , sender:UIButton){
        getOrderById(orderId: order.id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let orderResponse = ElementOrder(mas: value as! [String : Any])
                if orderResponse.status != 4{
                    order.status = status
                    self.putNewOrder(order: order, status: status, sender: sender)
                } else {
                    //                    self.view.makeToast("Заказ уже был отменен пользователем")
                    self.orders.remove(at: sender.tag)
                    self.collection.reloadData()
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
    
    func putNewOrder(order : ElementOrder, status : Int , sender:UIButton){
        patchOrder(order: order).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.setStatusView(btn: sender, status: order.status)
                self.orders[sender.tag] = order
                if order.status == 3{
                    self.orders.remove(at: sender.tag)
                    self.collection.reloadData()
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
    
    func setStatusView(btn: UIButton, status: Int){
        btn.setTitle("\(self.statuses[status])", for: UIControl.State())
        btn.layer.backgroundColor = self.statusColors[status]?.cgColor
    }
    
    @objc func cellOpened(sender:UIButton) {
        btnStatusClick(index: sender.tag, sender: sender)
    }
    
}
