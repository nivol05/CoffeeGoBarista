//
//  GroupCollectionAdapter.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation
import UIKit

class GroupCollectionAdapter: NSObject, UICollectionViewDelegate , UICollectionViewDataSource{
    
    var cashBoxVC : MainCashBoxVC!
    var list: [GroupElem]?
    
    func setData(cashBoxVC: MainCashBoxVC, list: [GroupElem]){
        self.cashBoxVC = cashBoxVC
        self.list = list
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItem", for: indexPath) as! MenuItemCell
        let item = list![indexPath.row]
        
        if item.img != nil{
            cell.itemImage.kf.setImage(with: URL(string: item.img!)!)
        } else{
            cell.itemImage.image = #imageLiteral(resourceName: "coffee-cup")
        }
        
        switch item.type {
        case 1:
            cell.itemNameLbl.text = "Кофе"
            break
        case 2:
            cell.itemNameLbl.text = "Десерты"
            break
        case 9:
            cell.itemNameLbl.text = "Холодные напитки"
            break
        case 10:
            cell.itemNameLbl.text = "Еда"
            break
        case 12:
            cell.itemNameLbl.text = "Гарячие напитки"
            break
        default:
            cell.itemNameLbl.text = "Другое"
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cashBoxVC.setProducts(type: list![indexPath.row].type)
    }
}
