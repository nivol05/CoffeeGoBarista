//
//  TableSyrups.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 2/22/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation
import UIKit

class TableSyrups: NSObject, UITableViewDelegate,UITableViewDataSource {
    
    var orderItems : [ElementOrderItem]!
    var order : ElementOrder!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderItems == nil{
            return 0
        }
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItems", for: indexPath) as? OrderItems
        
        let orderItem = orderItems[indexPath.row]
        let product_id = orderItem.product
        var element : ElementProduct!
        for i in menu{
            if product_id == i.id{
                element = i
                break
            }
        }
        
        //CoffeeImag
        if element.img != nil{
            cell?.ImgCoffee.kf.setImage(with: URL(string: element.img)!)
        } else{
            cell?.ImgCoffee.image = #imageLiteral(resourceName: "coffee-cup")
        }
        
        cell?.LblName.text = element.name
        
        
        var coffee_price = ""
        switch "\(orderItem.cup_size!)"{
            
        case "l":
            coffee_price += "\(element.l_cup!)"
            break
        case "m":
            coffee_price +=  "\(element.m_cup!)"
            break
        case "b":
            coffee_price += "\(element.b_cup!)"
            break
        default:
            coffee_price += "\(element.price!)"
        }
        coffee_price += " грн"
        cell?.LblPrice.text = coffee_price
        //            " " + context.getString(R.string.grn)
        
        let sugar = orderItem.sugar
        let species = "\(orderItem.species!)"
        
        
        //        cell?.LbllAdditions.text = ("\(ordersElements["additionals"]!)")
        
        if orderItem.syrups != nil && orderItem.syrups != ""{ // Making syrups string
            let syrupsInStr = orderItem.syrups.components(separatedBy: ", ")
            var syrupsText = "Сиропы: "
            for i in 0..<syrupsInStr.count{
                let value = syrupsInStr[i]
                
                for x in syrups{
                    if value == x["name"] as! String{
                        syrupsText.append(x["name"] as! String)
                        syrupsText.append("( +\(x["price"] as! Int) грн)")
                        break
                    }
                }
                
                
                if i != syrupsInStr.count - 1{
                    syrupsText.append(", ")
                }
            }
            cell?.LblSyrup.text = syrupsText
        } else {
            cell?.LblSyrup.text = ""
        }
        
        if orderItem.additionals != nil && orderItem.additionals != ""{ // Making adds string
            let addsInStr = orderItem.additionals.components(separatedBy: ", ")
            var addsText = "Добавки: "
            for i in 0..<addsInStr.count{
                let value = addsInStr[i]
                
                for x in additionals{
                    if value == x["name"] as! String{
                        addsText.append(x["name"] as! String)
                        addsText.append("( +\(x["price"] as! Int) грн)")
                        break
                    }
                }
                
                
                if i != addsInStr.count - 1{
                    addsText.append(", ")
                }
            }
            cell?.LbllAdditions.text = addsText
        } else {
            cell?.LbllAdditions.text = ""
        }
        
        if species != ""{
            cell?.LblSpice.text = "Специи: \(species)"
        } else {
            cell?.LblSpice.text = ""
        }
        
        if sugar != 0.0 {
            cell?.LblSugar.text = "Сахар: \(sugar!)"
        } else {
            cell?.LblSugar.text = ""
        }
        //        cell?.LblSugar.text = "Сахар: \(sugar!)"
        
        cell?.LblUltPrice.text = "Всего: \((orderItem.item_price + orderItem.additionals_price)) грн"
        
        
        return cell!
    }
    
    override init(){
        
    }
    
    func setValues (items: [ElementOrderItem], order: ElementOrder) {
        orderItems = items
        self.order = order
    }
}
