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
var menu : [ElementProduct]!
var additionals : [[String: Any]] = [[String: Any]]()
var syrups : [[String: Any]] = [[String: Any]]()
var tabs : [Int]!
var updateCashBoxList = true
var notif = true

var orderVCVisible = false

func getProductsForType(type: Int) -> [ElementProduct]{
    var products = [ElementProduct]()
    for product in menu{
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

func getCurrentDate() -> String{
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: today)
}

func isToday(date: String) -> Bool{
    let checkingDate = getDate(dateString: date)
    let today = getDate(dateString: getCurrentDate())
    return checkingDate == today
}

func isBeforeToday(date: String) -> Bool{
    let checkingDate = getDate(dateString: date)
    let today = getDate(dateString: getCurrentDate())
    return checkingDate <= today
}
