//
//  staticData.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 30.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import UIKit

var current_coffee_spot : ElementCoffeeSpot!
var tabs : [Int]!
var updateCashBoxList = true
var notif = true

let db = DBBarista()

var orderVCVisible = false

var openInventory = false

func getProductsForType(type: Int) -> [ElementProduct]{
    var products = [ElementProduct]()
    for product in db.getProducts(){
        if product.product_type == type{
            products.append(product)
        }
    }
    return products
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
