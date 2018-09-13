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

        getOrders()

    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        //        var screenSize = screenWidth
        
        var width = screenWidth - (2 * 12)
        print(screenWidth)
        if screenWidth >= 750 {
            width = screenWidth / 3.3
            //            widthConstraint.constant = screenWidth - 30
        }
        if screenWidth <= 750 && screenWidth > 667{
            width = screenWidth / 3.3
        }
        if screenWidth == 667{
            width = screenWidth / 2.2
        }
        if screenWidth == 568{
            width = screenWidth / 2.2
        }
        return CGSize(width: CGFloat((width)), height: CGFloat((132)))
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cashbox", for: indexPath) as! CashboxList
        let index = orders[indexPath.row]
        cell.LblPrice.text = "\(index["full_price"]!) грн"
        cell.LblTime.text = index["order_time"] as? String
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
    
    func getOrders(){
        let isUser = "\(BASE_URL)\(List2_Order)\(staticData.spotId)"
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            if response.result.isSuccess {
                self.orders = response.result.value as! [[String : Any]]
                self.collection.dataSource = self
                self.collection.delegate = self
            } else {
                print("Hui")
            }
        }
    }
    @IBAction func dropDownView(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.DropView.isHidden = !self.DropView.isHidden
//            self.view.layoutIfNeeded()
        })
    }
    
}
