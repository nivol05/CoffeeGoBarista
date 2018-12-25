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


class CashBoxVC: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var DropView: UIView!
    @IBOutlet weak var minDate: UITextField!
    @IBOutlet weak var maxDate: UITextField!
    @IBOutlet weak var cancel: UIButton!
    
    let toolbar = UIToolbar()
    let pickedMax = UIDatePicker()
    let pickedMin = UIDatePicker()
    var minChoosed = false
    var maxChoosed = false
    
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
        toolbar.sizeToFit()
        getOrders(filtered: false)
        
        
        
        maxDate.addTarget(self, action: #selector(checkActionMax), for: UIControl.Event.touchDown)
        minDate.addTarget(self, action: #selector(checkActionMin), for: UIControl.Event.touchDown)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if orders == nil{
            return 0
        }
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cashbox", for: indexPath) as! CashboxList
        let item = orders[indexPath.row]
        
        cell.orderIndex.text = "\(indexPath.row + 1)"
        cell.LblPrice.text = "Сумма: \(item.full_price!) грн"
        cell.LblTime.text = "Время: \(item.order_time!)"
        cell.LblOrderRow.text = item.date
        cell.BtnStatus.setTitle("\(self.statuses[item.status])", for: UIControl.State())
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "OrderPage") as! OrderListVC
        cell.Id = self.orders[indexPath.row].id
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    func getOrders(filtered : Bool){
        getOrdersListTwo().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.orders = setElementOrderList(list: value as! [[String : Any]])
                if filtered{
                    
                    if !self.maxChoosed && !self.minChoosed{
                        self.collection.reloadData()
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
                        self.collection.reloadData()
                    }
                }
                self.collection.dataSource = self
                self.collection.delegate = self
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
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
    
    
    func dateInRange(date : Date, start : Date, end : Date) -> Bool{
        return (date <= start && date >= end)
            || (date >= start && date <= end)
    }
    
    @objc func showMinDate(){
        minChoosed = true
        cancel.isHidden = false
        if maxChoosed && minChoosed{
            getOrders(filtered: true)
        }
        
        minDate.text = getDateString(date: pickedMin.date)
        self.view.endEditing(true)
    }
    
    
    @objc func showMaxDate(){
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
    
    func setDefaultsDatePicker(){
        minChoosed = false
        maxChoosed = false
        minDate.text = "Выберите дату"
        maxDate.text = "Выберите дату"
    }
    
    @IBAction func dropDownView(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.DropView.isHidden = !self.DropView.isHidden
        })

    }
    
}
