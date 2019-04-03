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

class CashBoxVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,NVActivityIndicatorViewable {
    
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
    
    var refresh : UIRefreshControl!
    
    let toolbar = UIToolbar()
    let pickedMax = UIDatePicker()
    let pickedMin = UIDatePicker()
    
    var minChoosed = false
    var maxChoosed = false
    var changeCashBoxList = false
    
    var allOrderCost = 0
    
    var orders : [ElementOrder]!
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
        
        
//        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        toolbar.sizeToFit()
        maxDate.addTarget(self, action: #selector(checkActionMax), for: UIControl.Event.touchDown)
        minDate.addTarget(self, action: #selector(checkActionMin), for: UIControl.Event.touchDown)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        if changeCashBoxList{
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
        if orders.count == 0{
            emptyView.isHidden = false
        }
        
        if orders == nil{
            emptyView.isHidden = false
            return 0
        }
        return orders.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if changeCashBoxList{
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecCell", for: indexPath)
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if changeCashBoxList{
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let cell = Storyboard.instantiateViewController(withIdentifier: "OrderPage") as! OrderListVC
            cell.Id = self.orders[indexPath.row].id
            self.navigationController?.pushViewController(cell, animated: true)
        } else {
            presentPopup(popupVC: OffineOrderListVC(), mainVC: self)
        }
    }
    
    func getAllOrderPrice(filtered: Bool){
        var allPrice = 0
        for order in orders{
            allPrice += order.full_price
        }
        if filtered{
            titleLbl.text = "Выбранные заказы (\(orders.count)) на сумму: \(allPrice) грн"
        } else{
            titleLbl.text = "Все заказы (\(orders.count)) на сумму: \(allPrice) грн"
        }
    }
    
    func getOrders(filtered : Bool){
        print("TYTA I")
        getOrdersListTwo().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                self.orders = setElementList(list: value as! [[String : Any]])
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
                        self.collection.reloadData()
                    }
                } else{
                    self.getAllOrderPrice(filtered: false)
                }
                
               self.refresh.endRefreshing()
                self.collection.dataSource = self
                self.collection.delegate = self
//                self.getAllOrderPrice()
                self.loading(activity: false)
                self.stopAnimating()
                break
            case .failure(let error):
                
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.refresh.endRefreshing()
                self.emptyView.isHidden = false
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
        getOrders(filtered: false)
    }
    
    @IBAction func changeCashBoxList(_ sender: Any) {
        if changeCashBoxList{
            collection.reloadData()
            changeCashBoxList.toggle()
        } else {
            collection.reloadData()
            changeCashBoxList.toggle()
        }
    }
    
    
}
