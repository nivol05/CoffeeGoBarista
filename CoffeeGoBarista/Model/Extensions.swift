//
//  Extensions.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/20/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation

extension Bool{
    func getInt() -> Int {
        if (self){
            return 1
        } else {
            return 0
        }
    }
}

extension String{
    func getIntArray() -> [Int]{
        let strings = self.split(separator: ",")
        var res = [Int]()
        for x in strings{
            res.append(Int(x)!)
        }
        return res
    }
    
    func getSignedStr() -> String{
        return "\(self) ₴"
    }
    
    func getDeSignedStr() -> String{
        //        return String(text.split(separator: " ")[0])
        return String(self[self.startIndex..<self.index(self.endIndex, offsetBy: -2)])
    }
    
}

extension Array{
    func getString() -> String {
        var res = ""
        for x in self{
            res.append("\(x),")
        }
        return res
    }
    
    func getItem(id: Int) -> ElementProduct?{
        for item in self as! [ElementProduct]{
            if (item.id == id){
                return item
            }
        }
        return nil
    }
}

extension OrderItemOfflineElem{
    func getName(products: [ElementProduct], adds: [AdditionalElem], syrups: [SyrupElem]) -> String {
        if (self.product != nil){
            for item in products{
                if (self.product == item.id){
                    return item.name
                }
            }
        } else if (self.additionals != nil){
            for item in adds{
                if (self.additionals == item.id){
                    return item.name
                }
            }
        } else{
            for item in syrups{
                if (self.syrups == item.id){
                    return item.name
                }
            }
        }
        return ""
    }
    
    func getSinglePrice(products: [ElementProduct], adds: [AdditionalElem], syrups: [SyrupElem]) -> Int {
        if (self.product != nil){
            for item in products{
                if (self.product == item.id){
                    switch (self.cup){
                    case "l":
                        return item.l_cup
                    case "m":
                        return item.m_cup
                    case "b":
                        return item.b_cup
                    default:
                        return item.price
                    }
                }
            }
        } else if (self.additionals != nil){
            for item in adds{
                if (self.additionals == item.id){
                    return item.price
                }
            }
        } else{
            for item in syrups{
                if (self.syrups == item.id){
                    return item.price
                }
            }
        }
        return 0
    }
    
    func getFullPrice(products: [ElementProduct], adds: [AdditionalElem], syrups: [SyrupElem]) -> Int {
        let price = getSinglePrice(products: products, adds: adds, syrups: syrups)
        let final =  Float(price) * Float(count) * (1.0 - Float(discount) / 100.0)
        return Int(final)
    }
    
    func getCup(products: [ElementProduct]) -> String{
        if (product == nil){
            return "-"
        } else{
            let product = products.getItem(id: self.product!)!
            switch (cup){
            case "l":
                if (product.cups != nil && product.cups!.count >= 1){
                    return getCupSize(id: product.cups![0])
                }
                break
            case "m":
                if (product.cups != nil && product.cups!.count >= 2){
                    return getCupSize(id: product.cups![1])
                }
                break
            case "b":
                if (product.cups != nil && product.cups!.count >= 3){
                    return getCupSize(id: product.cups![2])
                }
                break
            default:
                if (product.cups != nil && product.cups!.count >= 1){
                    return getCupSize(id: product.cups![0])
                }
            }
        }
        return "-"
    }
}
