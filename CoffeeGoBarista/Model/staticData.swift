//
//  staticData.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 30.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import UIKit

var tabs : [Int]!
var updateCashBoxList = true
var notif = true

let utilityQueue = DispatchQueue.global(qos: .utility)

let db = DBBarista()

var orderVCVisible = false

var openInventory = false
var inventoryType: InventoryType!

enum InventoryType{
    case Inventorization
    case Income
    case ProductOutcome
}

func getProductsForType(type: Int) -> [ElementProduct]{
//    var products = [ElementProduct]()
//
//    for product in db.getProducts(){
//        if product.product_type == type{
//            products.append(product)
//        }
//    }
    return db.getProducts().filter({$0.product_type == type})
}

func setNotifsEnabled(enabled: Bool){
    let preferences = UserDefaults.standard
    preferences.set(enabled, forKey: "notifs_enabled")
    preferences.synchronize()
}

func isNotifsEnabled() -> Bool{
    let preferences = UserDefaults.standard
    
    let info = "notifs_enabled"
    
    if preferences.object(forKey: info) == nil {
        return true
    } else {
        return preferences.bool(forKey: info)
    }
}

func setLogin(login: String){
    let preferences = UserDefaults.standard
    preferences.set(login, forKey: "user_login")
    preferences.synchronize()
}

func getLogin() -> String{
    let preferences = UserDefaults.standard
    return preferences.string(forKey: "user_login") ?? ""
}

func setBaristaName(value: String){
    let preferences = UserDefaults.standard
    preferences.set(value, forKey: "barista_name")
    preferences.synchronize()
}

func getBaristaName() -> String{
    let preferences = UserDefaults.standard
    return preferences.string(forKey: "barista_name") ?? ""
}

func setUserToken(login: String){
    let preferences = UserDefaults.standard
    preferences.set("Token \(login)", forKey: "user_token")
    preferences.synchronize()
}

func getUserToken() -> String{
    let preferences = UserDefaults.standard
    return preferences.string(forKey: "user_token") ?? ""
}

func setSpotId(id: Int){
    let preferences = UserDefaults.standard
    preferences.set(id, forKey: "spot_id")
    preferences.synchronize()
}

func getSpotId() -> Int{
    let preferences = UserDefaults.standard
    return preferences.integer(forKey: "spot_id")
}

func setMaxOrderLimit(value: String){
    let preferences = UserDefaults.standard
    preferences.set(value, forKey: "max_order_limit")
    preferences.synchronize()
}

func getMaxOrderLimit() -> String{
    let preferences = UserDefaults.standard
    return preferences.string(forKey: "max_order_limit") ?? "0"
}

func setCashBoxEnabled(value: Bool){
    let preferences = UserDefaults.standard
    preferences.set(value, forKey: "cashbox")
    preferences.synchronize()
}

func isCashBoxEnabled() -> Bool{
    let preferences = UserDefaults.standard
    return preferences.bool(forKey: "cashbox")
}

func setOnlineEnabled(value: Bool){
    let preferences = UserDefaults.standard
    preferences.set(value, forKey: "coffeego")
    preferences.synchronize()
}

func isOnlineEnabled() -> Bool{
    let preferences = UserDefaults.standard
    return preferences.bool(forKey: "coffeego")
}

func setInventoryProcess(value: Bool){
    let preferences = UserDefaults.standard
    preferences.set(value, forKey: "inv")
    preferences.synchronize()
}

func isInventoryInProcess() -> Bool{
    let preferences = UserDefaults.standard
    return preferences.bool(forKey: "inv")
}
