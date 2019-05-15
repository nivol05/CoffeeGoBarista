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
import NVActivityIndicatorView
import Toast_Swift
import PopupDialog

class OrderVC: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , NVActivityIndicatorViewable , UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var collection: UICollectionView!
    
    //COW - cancel order window
    @IBOutlet weak var COW: UIView!
    @IBOutlet weak var bgCOWView: UIView!
    @IBOutlet weak var confirmCOWBtn: UIButton!
    @IBOutlet weak var reasonCOWTF: UITextView!
    @IBOutlet weak var cancelCOWBtn: UIButton!
    
    var refresh : UIRefreshControl!
    
    var COWsender: UIButton!
    
    
    static var isChangingStatus : Bool!
    var orders : [ElementOrder]!
    
    var time = 0
    
    var timer : Timer!
    
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
        
        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(OrderVC.refreshPage), for: UIControlEvents.valueChanged)
        //            refresh.
        collection.addSubview(refresh)
        
        
        style()
        AppDelegate.enableNotif()
        
            
//            startAnimating(type : NVActivityIndicatorType.ballPulseSync)
            OrderVC.isChangingStatus = true

        self.collection.dataSource = self
        self.collection.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(OrderVC.sayHello), userInfo: nil, repeats: true)
        
        orderVCVisible = true
        if Connectivity.isConnectedToInternet() {
            collection.isHidden = false
//            internetTrobleView.isHidden = true
            getOrders()
        } else {
            collection.isHidden = true
//            internetTrobleView.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        
        orderVCVisible = false
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIScreen.main.bounds.width < 1000{
            return CGSize(width: UIScreen.main.bounds.width / 3 - 20 , height: 165)
        } else {
            return CGSize(width: 230 , height: 180)
        }
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
        cell.nameLbl.text = "\(order.username!)"
        cell.buttonBG.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
        
        cell.cancelOrderBtn.addTarget(self, action: #selector(cancelOrder(sender:)), for: .touchUpInside)
       
        self.setStatusView(btn: cell.buttonBG, status: order.status)
        let mins = toMins(time: order.order_time)
        
        var minsToOrder = mins - toMins(time: getTimeNow())
        
        if !isToday(date: order.date!){
            if isBeforeToday(date: order.date){
                cell.orderlbl.text = order.date!
            } else {
                if minsToOrder < 0 {
                    minsToOrder += 1440 // 1440 mins in 24 hrs
                }
                cell.orderlbl.text = "Через \(minsToOrder) мин"
            }
        } else {
            cell.orderlbl.text = "Через \(minsToOrder) мин"
        }
        
        if order.status == 1{
            cell.cancelOrderBtn.isHidden = false
        } else {
            cell.cancelOrderBtn.isHidden = true
            
        }
        
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
        getOrders()
        print("Tyt")
        collection.reloadData()
    }
    
    func getOrders(){
        
        getOrdersListOne().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.sortByTime(orders : setElementList(list: value as! [[String : Any]]))
                self.collection.reloadData()
                self.refresh.endRefreshing()
                self.stopAnimating()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.emptyView.isHidden = false
                self.refresh.endRefreshing()
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func sortByTime(orders : [ElementOrder]){
        
        var sortedOrders = [ElementOrder]()
        if orders.count == 0{
            self.orders = sortedOrders
            emptyView.isHidden = false
            return
        } else {
            emptyView.isHidden = true
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
            checkOrder(order: order, status: 3, sender: sender)
        }
//        }else if order.status == 3{
//            checkOrder(order: order, status: 7, sender: sender, closeBtn: closeBtn)
//        } else if order.status == 7{
//            checkOrder(order: order, status: 3, sender: sender, closeBtn: closeBtn)
//        }
    }
    
    func checkOrder(order : ElementOrder, status : Int , sender:UIButton){
//        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        
        getOrderById(orderId: order.id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let orderResponse = ElementOrder(mas: value as! [String : Any])
                if orderResponse.status != 4{
                    order.status = status
                    self.putNewOrder(order: order, status: status, sender: sender)
                } else {
                    self.view.makeToast("Заказ уже был отменен пользователем")
                    self.orders.remove(at: sender.tag)
                    if self.orders.count == 0{
                        self.emptyView.isHidden = false
                    } else{
                        self.emptyView.isHidden = true
                    }
                    self.stopAnimating()
                    self.collection.reloadData()
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
    
    func putNewOrder(order : ElementOrder, status : Int , sender:UIButton){
        
        if isCashBoxEnabled() && status == 3{
            stopAnimating()
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cell = Storyboard.instantiateViewController(withIdentifier: "confirmOrderVC") as! ConfirmOrderVC
            self.navigationController?.pushViewController(cell, animated: true)
            cell.setOnlineData(order: order, maxValue: order.full_price, success: {
                self.orders.remove(at: sender.tag)
            })
            return
        }
        
        if order.status == 6{
            order.canceled_barista_message = reasonCOWTF.text!
        }
        patchOrder(order: order).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.setStatusView(btn: sender, status: order.status)
                if order.status == 3 || order.status == 6{
                    self.COW.isHidden = true
                    self.reasonCOWTF.text = ""
                    updateCashBoxList = true
                    self.orders.remove(at: sender.tag)
                } else {
                    self.orders[sender.tag] = order
                }
                
                if self.orders.count == 0{
                    self.emptyView.isHidden = false
                } else{
                    self.emptyView.isHidden = true
                }
                self.stopAnimating()
                self.collection.reloadData()

                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func setStatusView(btn: UIButton, status: Int){
        btn.setTitle("\(self.statuses[status])", for: UIControl.State())
        btn.layer.backgroundColor = self.statusColors[status]?.cgColor
    }
    
    func showStandardDialog(animated: Bool = true , sender : UIButton) {
        
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
            self.checkOrder(order: self.orders[sender.tag], status: 6, sender: sender)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    @objc func cellOpened(sender:UIButton) {
        btnStatusClick(index: sender.tag, sender: sender)
    }
    
    @objc func cancelOrder(sender:UIButton) {
//        showStandardDialog(sender: sender)
        COW.isHidden = false
        fadeView(view: COW, delay: 0, isHiden: false)
        COWsender = sender
    }
    @IBAction func confirmCOWBtn(_ sender: Any) {
        self.checkOrder(order: self.orders[COWsender.tag], status: 6, sender: COWsender)
    }
    
    @IBAction func cancelCOWBtn(_ sender: Any) {
//        COW.isHidden = true
        fadeView(view: COW, delay: 0, isHiden: true)
        self.reasonCOWTF.text = ""
    }
    
    @objc func refreshPage(){
        getOrders()
        
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            collection.isHidden = false
            //            internetTrobleView.isHidden = true
            getOrders()
        }
    }
    
}
