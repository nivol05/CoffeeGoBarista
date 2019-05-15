//
//  LoadUtils.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/15/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation
import Alamofire

class LoadUtils{
    private let funcError: () -> ()
    private let funcSuccess: () -> ()
    private var productList: [ElementProduct]!
    private var addsList: [AdditionalElem]!
    private var syrupsList: [SyrupElem]!
    private var cupsList: [CupElement]!
    private var discountList: [Discount]!
    private var storageItems: [StorageItemElem]!
    private var storageItemsType: [StorageItemType]!
    
    init(error: @escaping () -> (), success: @escaping () -> ()) {
        self.funcError = error
        self.funcSuccess = success
    }
    
    func startDownloading(){
        
        print("GET MANU")
        
        self.getMenu()
    }
    
    private func clearData(){
        productList = nil
        addsList = nil
        syrupsList = nil
        cupsList = nil
        discountList = nil
        storageItems = nil
        storageItemsType = nil
    }
    
    private func saveAll(){
        
        db.setProducts(list: productList)
        db.setAdds(list: addsList)
        db.setSyrups(list: syrupsList)
        db.setCups(list: cupsList)
        db.setDiscounts(list: discountList)
        db.setStorageTypes(list: storageItemsType)
        
        db.setStorageItems(list: storageItems)
        
        self.funcSuccess()
        self.clearData()
    }
    
    private func getMenu(){
        getProductsForSpot().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.productList = setElementList(list: value as! [[String : Any]])
                self.getAdds()
                break
            case .failure(let error):
                print(error)
                self.funcError()
                self.clearData()
                break
            }
        }
    }
    
    private func getAdds(){
        getAdditionalsForSpot(spotId: "\(getSpotId())").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.addsList = setElementList(list: value as! [[String : Any]])
                self.getSyrups()
                break
            case .failure(let error):
                self.funcError()
                self.clearData()
                print(error)
                break
            }
        }
    }
    
    private func getSyrups(){
        getSyrupsForSpot(spotId: "\(getSpotId())").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.syrupsList = setElementList(list: value as! [[String : Any]])
                self.getCupList()
                break
            case .failure(let error):
                self.funcError()
                self.clearData()
                print(error)
                break
            }
        }
    }
    
    private func getCupList(){
        getCups(spotId: getSpotId()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.cupsList = setElementList(list: value as! [[String : Any]])
                self.getDiscountList()
                break
            case .failure(let error):
                self.funcError()
                self.clearData()
                print(error)
                break
            }
        }
    }
    
    private func getDiscountList(){
        getDiscounts(spotId: getSpotId()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.discountList = setElementList(list: value as! [[String : Any]])
                self.getStorageItemsList()
                break
            case .failure(let error):
                self.funcError()
                self.clearData()
                print(error)
                break
            }
        }
    }
    
    private func getStorageItemsList(){
        getStorageItems(spotId: getSpotId()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.storageItems = setElementList(list: value as! [[String : Any]])
                self.getStorageItemsTypesList()
                break
            case .failure(let error):
                self.funcError()
                self.clearData()
                print(error)
                break
            }
        }
    }
    
    private func getStorageItemsTypesList(){
        getStorageItemsProductType(spotId: getSpotId()).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                self.storageItemsType = setElementList(list: value as! [[String : Any]])
                self.saveAll()
                break
            case .failure(let error):
                self.funcError()
                self.clearData()
                print(error)
                break
            }
        }
    }
}
