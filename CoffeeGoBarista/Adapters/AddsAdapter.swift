//
//  AddsAdapter.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/28/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation
import UIKit

class AddsAdapter: NSObject, UICollectionViewDelegate , UICollectionViewDataSource{
    
    var cashBoxVC : MainCashBoxVC!
    var list: [AdditionalElem]!
    var searchList: [AdditionalElem]!
    
    func setData(cashBoxVC: MainCashBoxVC, list: [AdditionalElem]){
        self.cashBoxVC = cashBoxVC
        self.list = list
        searchList = list
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItem", for: indexPath) as! MenuItemCell
        cell.itemNameLbl.text = searchList[indexPath.row].name
        cell.itemLbl.text = "Добавка"
        cell.itemImage.image = nil
        cell.itemLbl.isHidden = false
        //        cell.itemImage.kf.setImage()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            cashBoxVC.addOrderItem(cashOrderItem: AdditionalOrderItem(additional: searchList[indexPath.row]))
    }
    
    func setFoundedResponses(elems: [AdditionalElem]){
        self.searchList = elems
        cashBoxVC.tableView.reloadData()
    }
    
    func setPrevious(){
        self.list = self.searchList
        cashBoxVC.tableView.reloadData()
    }
}
