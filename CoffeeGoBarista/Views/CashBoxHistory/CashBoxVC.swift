//
//  CashBoxVC.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 01.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class CashBoxVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,NVActivityIndicatorViewable {
    
    
    
    @IBOutlet weak var changeListSC: UISegmentedControl!
    @IBOutlet weak var titile: UINavigationItem!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var DropView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var minDate: UITextField!
    @IBOutlet weak var maxDate: UITextField!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var chooseDateBtn: UIButton!
    
    var refresh : UIRefreshControl!
    
    let toolbar = UIToolbar()
    let pickedMax = UIDatePicker()
    let pickedMin = UIDatePicker()
    
    var minChoosed = false
    var maxChoosed = false
    var isOnlineOrders : Bool!
    
    var allOrderCost = 0
    
    var orders : [ElementOrder]!
    var ordersOffline: [OrderOffline]!
    let statuses = [
        "",
        "Подтвердить",
        "Готовлю",
        "Завершено",
        "Отклонено клиентом",
        "Завершить приготовление",
        "Отклонено заведением",
        "Завершить заказ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.addTarget(self, action: #selector(CashBoxVC.refreshPage), for: UIControlEvents.valueChanged)
        
        collection.addSubview(refresh)
        
        cornerRatio(view: calendarBtn, ratio: 5, masksToBounds: false)
        
        self.collection.register(UINib(nibName: "OfflineCashBoxCell", bundle: nil), forCellWithReuseIdentifier: "SecCell")
        
        if isCashBoxEnabled(){
            isOnlineOrders = false
            chooseDateBtn.isHidden = true
        } else {
            isOnlineOrders = true
            chooseDateBtn.isHidden = false
        }
        
        if isCashBoxEnabled(){
            changeListSC.isHidden = false
        } else{
            changeListSC.isHidden = true
        }
        
//        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        toolbar.sizeToFit()
        maxDate.addTarget(self, action: #selector(checkActionMax), for: UIControl.Event.touchDown)
        minDate.addTarget(self, action: #selector(checkActionMin), for: UIControl.Event.touchDown)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isCashBoxEnabled(){
            ordersOffline = db.getOrdersOffline()
            ordersOffline.reverse()
        }
        self.orders = db.getOrdersOnline()
        getOrders(filtered: false)
        self.collection.dataSource = self
        self.collection.delegate = self
        self.collection.reloadData()
        
        if updateCashBoxList{
            loading(activity: true)
            getOrders(filtered: true)
//            collection.reloadData()
            updateCashBoxList = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isOnlineOrders{
            if UIScreen.main.bounds.width < 1000{
                return CGSize(width: UIScreen.main.bounds.width / 3 - 20 , height: 155)
            }
            else {
                return CGSize(width: 230 , height: 155)
            }
        } else {
            return CGSize(width: 230 , height: 120)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isOnlineOrders{
            if orders == nil || orders.count == 0{
                emptyView.isHidden = false
                return 0
            }
            return orders.count
        } else {
            if ordersOffline == nil || ordersOffline.count == 0{
                emptyView.isHidden = false
                return 0
            }
            return ordersOffline.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isOnlineOrders{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cashbox", for: indexPath) as! CashboxList
            let item = orders[indexPath.row]
            
            cell.orderIndex.text = "\(indexPath.row + 1)"
            cell.LblPrice.text = "Сумма: \(item.full_price!) грн"
            cell.LblTime.text = "Время: \(item.order_time!)"
            //        cell.nameLbl.text = "\(order.username!)"
            cell.LblOrderRow.text = item.date
            cell.BtnStatus.setTitle("\(self.statuses[item.status])", for: UIControl.State())
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecCell", for: indexPath) as! OfflineCashBoxCell
            let item = ordersOffline[indexPath.row]
            
            cell.positionLbl.text = "\(ordersOffline.count - indexPath.row)"
            cell.sumLbl.text = "Наличные: \(item.cash_payment!) грн"
            cell.timelbl.text = "Карточка: \(item.card_payment!)"
//                    cell.nameLbl.text = "\(order.username!)"
            cell.dateLbl.text = item.order_time
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isOnlineOrders{
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cell = Storyboard.instantiateViewController(withIdentifier: "OrderPage") as! OrderListVC
            cell.Id = self.orders[indexPath.row].id
            self.navigationController?.pushViewController(cell, animated: true)
        } else {
            let cell = OffineOrderListVC()
            cell.setData(
                order: self.ordersOffline[indexPath.row]
            )
            cell.orderIndex = "Заказ \(ordersOffline.count - indexPath.row)"
            

            presentPopup(popupVC: cell, mainVC: self)
        }
    }
    
    func getAllOrderPrice(filtered: Bool = false){
        var allPrice = 0
        if isOnlineOrders{
            for order in orders{
                allPrice += order.full_price
            }
            if filtered{
                titleLbl.text = "Заказы (\(orders.count)) на сумму: \(allPrice) грн"
            } else{
                titleLbl.text = "Заказы (\(orders.count)) на сумму: \(allPrice) грн"
            }
        } else {
            for order in ordersOffline{
                allPrice += order.full_price
            }
            titleLbl.text = "Заказы (\(ordersOffline.count)) на сумму: \(allPrice) грн"
        }
    }
    
    func getOrders(filtered : Bool){
        print("TYTA I")
        
        getOrdersListTwo().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                self.orders = setElementList(list: value as! [[String : Any]])
                db.delOrdersOnline()
                db.setOrdersOnline(elems: self.orders)
                if self.orders.count == 0{
                    self.emptyView.isHidden = false
                } else {
                     self.emptyView.isHidden = true
                }
                if filtered{
                    
                    if !self.maxChoosed && !self.minChoosed{
                        self.collection.reloadData()
                        self.getAllOrderPrice(filtered: false)
                    } else {
                        var filteredOrders = [ElementOrder]()
                        let startDate = getDate(dateString: self.minDate.text!)
                        let endDate = getDate(dateString: self.maxDate.text!)
                        
                        for n in 0..<self.orders.count {
                            let dateNow = getDate(dateString: self.orders[n].date)
                            if self.dateInRange(date: dateNow, start: startDate, end: endDate){
                                filteredOrders.append(self.orders[n])
                            }
                        }
                        
                        self.orders = filteredOrders
                        self.getAllOrderPrice(filtered: true)
                    }
                } else{
                    self.getAllOrderPrice(filtered: false)
                }
                
               self.refresh.endRefreshing()
//                self.getAllOrderPrice()
                self.loading(activity: false)
                self.collection.dataSource = self
                self.collection.delegate = self
                self.collection.reloadData()
                self.stopAnimating()
                break
            case .failure(let error):
                
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.refresh.endRefreshing()
//                self.emptyView.isHidden = false
                self.loading(activity: false)
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    
    func dateInRange(date : Date, start : Date, end : Date) -> Bool{
        return (date <= start && date >= end)
            || (date >= start && date <= end)
    }
    
    func setDefaultsDatePicker(){
        minChoosed = false
        maxChoosed = false
        minDate.text = "Выберите дату"
        maxDate.text = "Выберите дату"
    }
    
    func loading(activity : Bool){
        if activity{
            loadingActivity.isHidden = false
            loadingActivity.startAnimating()
        } else {
            loadingActivity.isHidden = true
            loadingActivity.stopAnimating()
        }
    }
    
    @objc func checkActionMax(sender : UITapGestureRecognizer) {
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.showMaxDate))
        toolbar.setItems([done], animated: false)
        maxDate.inputAccessoryView = toolbar
        maxDate.inputView = pickedMax
        pickedMax.datePickerMode = .date
        
    }
    
    @objc func checkActionMin(sender : UITapGestureRecognizer) {
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.showMinDate))
        toolbar.setItems([done], animated: false)
        minDate.inputAccessoryView = toolbar
        minDate.inputView = pickedMin
        pickedMin.datePickerMode = .date
        
    }
    
    @objc func showMinDate(){
        self.allOrderCost = 0
        minChoosed = true
        cancel.isHidden = false
        if maxChoosed && minChoosed{
            getOrders(filtered: true)
        }
        
        minDate.text = getDateString(date: pickedMin.date)
        self.view.endEditing(true)
    }
    
    @objc func showMaxDate(){
        self.allOrderCost = 0
        maxChoosed = true
        cancel.isHidden = false
        if maxChoosed && minChoosed{
            getOrders(filtered: true)
        }
        
        maxDate.text = getDateString(date: pickedMax.date)
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        setDefaultsDatePicker()
        
        getOrders(filtered: true)
        cancel.isHidden = true
    }
    
    @IBAction func dropDownView(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.DropView.isHidden = !self.DropView.isHidden
        })

    }
    
    @objc func refreshPage(){
        
        getOrders(filtered: true)
    }
    
    @IBAction func refreshBtn(_ sender: Any) {
        loading(activity: true)
        getOrders(filtered: true)
    }
    
    
    @IBAction func changeListSC(_ sender: Any) {
        emptyView.isHidden = true
        let getIndex = changeListSC.selectedSegmentIndex
        print(getIndex)
        switch (getIndex) {
        case 0:
            isOnlineOrders.toggle()
            chooseDateBtn.isHidden.toggle()
            collection.reloadData()
            UIView.animate(withDuration: 0.1, animations: {
                self.DropView.isHidden = true
            })
        case 1:
            isOnlineOrders.toggle()
            chooseDateBtn.isHidden.toggle()
            collection.reloadData()
            
        default: break
        }
        getAllOrderPrice()
    }
    
    
}
