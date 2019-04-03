//
//  CanceledClient.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/20/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CanceledClient: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , NVActivityIndicatorViewable , UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var orders: [ElementOrder]!
    
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
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.getOrders()
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if orders == nil{
            return 0
        }
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIScreen.main.bounds.width < 1000{
            return CGSize(width: UIScreen.main.bounds.width / 3 - 20 , height: 155)
        } else {
            return CGSize(width: 230 , height: 180)
        }
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
    
    func getOrders(){
        getOrdersCanceledClient().responseJSON { (response) in
            switch response.result{
            case .success(let value):
                self.orders = setElementList(list: value as! [[String : Any]])
                self.collectionView.reloadData()
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
}
