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
    
    var orders : [[String: Any]] = [[String: Any]]()
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
        toolbar.sizeToFit()
        getOrders(filtered: false)
        
        
        
        maxDate.addTarget(self, action: #selector(checkActionMax), for: UIControlEvents.touchDown)
        minDate.addTarget(self, action: #selector(checkActionMin), for: UIControlEvents.touchDown)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cashbox", for: indexPath) as! CashboxList
        let index = orders[indexPath.row]
        cell.orderIndex.text = "\(indexPath.row + 1)"
        cell.LblPrice.text = "Сумма: \(index["full_price"]!) грн"
        cell.LblTime.text = "Время: \(index["order_time"]!)"
        cell.LblOrderRow.text = index["date"] as? String
        cell.BtnStatus.setTitle("\(self.statuses[index["status"] as! Int])", for: UIControlState())
        cell.ConerRatio()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cell = Storyboard.instantiateViewController(withIdentifier: "OrderPage") as! OrderListVC
        cell.Id = self.orders[indexPath.row]["id"] as! Int
        self.navigationController?.pushViewController(cell, animated: true)
    }
    
    func getOrders(filtered : Bool){
        let isUser = "\(BASE_URL)\(List2_Order)\(staticData.spotId)"
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            if response.result.isSuccess {
                self.orders = response.result.value as! [[String : Any]]
                if filtered{
                    
                    if !self.maxChoosed && !self.minChoosed{
                        self.collection.reloadData()
                    } else {
                        var filteredOrders : [[String: Any]] = [[String: Any]]()

                        let dateformat = DateFormatter()
                        dateformat.dateFormat = "yyyy-MM-dd"
                    
                        for n in 0..<self.orders.count {
                            let test = self.orders[n]["date"] as? String
                            if self.dateInRange(date: test!, start: self.minDate.text!, end: self.maxDate.text!){
                                filteredOrders.append(self.orders[n])
                            }
                        }
                    
                        self.orders = filteredOrders
                        self.collection.reloadData()
                    }
                }
                self.collection.dataSource = self
                self.collection.delegate = self
            } else {
                print("Hui")
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
    
    
    func dateInRange(date : String, start : String, end : String) -> Bool{
//        if date <= start && date >= end{
//            return true
//        }
//        if date >= start && date <= end{
//            return true
//        }
        var dateMas = date.components(separatedBy: "-")
        var startMas = start.components(separatedBy: "-")
        var endMas = end.components(separatedBy: "-")

        if (Int(dateMas[0])! >= Int(startMas[0])! && Int(dateMas[0])! <= Int(endMas[0])!) || (Int(dateMas[0])! <= Int(startMas[0])! && Int(dateMas[0])! >= Int(endMas[0])!){
            if (Int(dateMas[1])! >= Int(startMas[1])! && Int(dateMas[1])! <= Int(endMas[1])!) || (Int(dateMas[1])! <= Int(startMas[1])! && Int(dateMas[1])! >= Int(endMas[1])!){
                if (Int(dateMas[2])! >= Int(startMas[2])! && Int(dateMas[2])! <= Int(endMas[2])!) || (Int(dateMas[2])! <= Int(startMas[2])! && Int(dateMas[2])! >= Int(endMas[2])!){
                    return true
                }
            }
        }

        return false
        }
    
    @objc func showMinDate(){
        minChoosed = true
        cancel.isHidden = false
        if maxChoosed && minChoosed{
            getOrders(filtered: true)
        }
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let string = dateformat.string(from: pickedMin.date)
        minDate.text = string
        self.view.endEditing(true)
    }
    
    
    @objc func showMaxDate(){
        maxChoosed = true
        cancel.isHidden = false
        if maxChoosed && minChoosed{
            getOrders(filtered: true)
        }
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let string = dateformat.string(from: pickedMax.date)
        maxDate.text = string
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        minChoosed = false
        maxChoosed = false
        minDate.text = "Выберите дату"
        maxDate.text = "Выберите дату"
        
        getOrders(filtered: true)
        cancel.isHidden = true
    }
    
    @IBAction func dropDownView(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.DropView.isHidden = !self.DropView.isHidden
        })

    }
    
}
