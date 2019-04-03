//
//  ProductsCashAdapter.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/20/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ProductsCashAdapter: NSObject, UICollectionViewDelegate , UICollectionViewDataSource{
    
    var cashBoxVC : MainCashBoxVC!
    var list: [ElementProduct]!
    var searchList: [ElementProduct]!
    
    func setData(cashBoxVC: MainCashBoxVC, list: [ElementProduct]){
        self.cashBoxVC = cashBoxVC
        self.list = list
        searchList = list
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItem", for: indexPath) as! MenuItemCell
        let product = searchList[indexPath.row]
        cell.itemNameLbl.text = product.name
        
        if product.img != nil{
            cell.itemImage.kf.setImage(with: URL(string: product.img!)!)
        } else{
            cell.itemImage.image = #imageLiteral(resourceName: "coffee-cup")
        }
//        cell.itemImage.kf.setImage()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if hasSizes(x: searchList[indexPath.row]) != 0{
            createCupSelction(cups: hasSizes(x: searchList[indexPath.row]), product: searchList[indexPath.row])
        } else {
            cashBoxVC.addOrderItem(cashOrderItem: ProductOrderItem(product: searchList[indexPath.row], cupSize: 0))
        }
    }
    
    func hasSizes(x: ElementProduct) -> Int{
        var sizes = 0
        if(x.l_cup != 0){
            sizes += 1
        }
        if(x.m_cup != 0){
            sizes += 1
        }
        if(x.b_cup != 0){
            sizes += 1
        }
        return sizes
    }
    
    private func createCupSelction(cups: Int, product: ElementProduct){
        var selections = [CupSelectElem]()
        for cup in 0..<cups{
            var price = product.price
            var size = ""
            if cups > 1{
                switch (cup){
                case 0:
                    size = "S"
                    price = product.l_cup
                    break
                case 1:
                    size = "M"
                    price = product.m_cup
                    break
                case 2:
                    size = "L"
                    price = product.b_cup
                    break
                default:
                    print("DEFAULT")
                }
            }
            if (cup <= product.cups!.count){
                let cupSize = getCupSize(id: product.cups![cup])
                if (!cupSize.isEmpty){
                    size = "\(cupSize) мл"
                }
            }
            selections.append(CupSelectElem(size: size,
                                            price: price!,
                                            action: {
                                                self.cashBoxVC.addOrderItem(cashOrderItem: ProductOrderItem(
                                                    product: product,
                                                    cupSize: cup + 1))
                                                }))
        }
        // OPEN VC FOR CUPS
        let cell = CupSelectionVC()
        cell.cups = selections
        cell.cashBoxVC = cashBoxVC
        cell.product = product
        presentPopup(popupVC: cell, mainVC: cashBoxVC)
        
    }
    
    func setFoundedResponses(elems: [ElementProduct]){
        self.searchList = elems
        cashBoxVC.tableView.reloadData()
    }
    
    func setPrevious(){
        self.list = self.searchList
        cashBoxVC.tableView.reloadData()
    }
}
