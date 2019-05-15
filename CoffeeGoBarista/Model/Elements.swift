//
//  CoffeeNetElement.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.10.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import SwiftyJSON

func setElementList(list: [[String : Any]]) -> [ElementProduct]{
    var ret = [ElementProduct]()
    for x in list{
        ret.append(ElementProduct(mas: x))
    }
    return ret
}

func setElementList(list: [[String : Any]]) -> [ElementOrder]{
    var ret = [ElementOrder]()
    for x in list{
        ret.append(ElementOrder(mas: x))
    }
    return ret
}

func setElementList(list: [[String : Any]]) -> [ElementOrderItem]{
    var ret = [ElementOrderItem]()
    for x in list{
        ret.append(ElementOrderItem(mas: x))
    }
    return ret
}

func setElementList(list: [[String : Any]]) -> [AdditionalElem]{
    var ret = [AdditionalElem]()
    for x in list{
        ret.append(AdditionalElem(mas: x))
    }
    return ret
}

func setElementList(list: [[String : Any]]) -> [SyrupElem]{
    var ret = [SyrupElem]()
    for x in list{
        ret.append(SyrupElem(mas: x))
    }
    return ret
}

func setElementList(list: [[String : Any]]) -> [CupElement]{
    var ret = [CupElement]()
    for x in list{
        ret.append(CupElement(mas: x))
    }
    return ret
}

func setElementList(list: [[String : Any]]) -> [Discount]{
    var ret = [Discount]()
    for x in list{
        ret.append(Discount(mas: x))
    }
    return ret
}

func setElementList(list: [[String : Any]]) -> [StorageItemElem]{
    var ret = [StorageItemElem]()
    for x in list{
        ret.append(StorageItemElem(mas: x))
    }
    return ret
}

func setElementList(list: [[String : Any]]) -> [StorageItemType]{
    var ret = [StorageItemType]()
    for x in list{
        ret.append(StorageItemType(mas: x))
    }
    return ret
}



class ElementOrderItem{
    var url : String!
    var id : Int!
    var order : Int!
    var product : Int!
    var sugar : Double!
    var additionals : String!
    var syrups : String!
    var species : String!
    var item_price : Int!
    var additionals_price : Int!
    var cup_size : String!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        order = mas["order"] as? Int
        url = mas["url"] as? String
        product = mas["product"] as? Int
        cup_size = mas["cup_size"] as? String
        sugar = mas["sugar"] as? Double
        additionals = mas["additionals"] as? String
        syrups = mas["syrups"] as? String
        species = mas["species"] as? String
        item_price = mas["item_price"] as? Int
        additionals_price = mas["additionals_price"] as? Int
    }
}

class ElementOrder{
    var id : Int!
    var user : Int!
    var username: String!
    var coffee_spot : Int!
    var full_price : Int!
    var date : String!
    var comment : String!
    var order_time : String!
    var status : Int!
    var takeaway : Bool!
    var canceled_barista_message : String!
    var cash_payment : Int!
    var card_payment : Int!
    var discount : Int!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        user = mas["user"] as? Int
        username = mas["username"] as? String
        coffee_spot = mas["coffee_spot"] as? Int
        full_price = mas["full_price"] as? Int
        date = mas["date"] as? String
        comment = mas["comment"] as? String
        order_time = mas["order_time"] as? String
        status = mas["status"] as? Int
        takeaway = mas["takeaway"] as? Bool
        canceled_barista_message = mas["canceled_barista_message"] as? String
        cash_payment = mas["cash_payment"] as? Int
        card_payment = mas["card_payment"] as? Int
        discount = mas["discount"] as? Int
    }
    
    init(){
        
    }
    
    func toPatch() -> [String : Any]{
        var mas = [String : Any]()
        if status != nil{
            mas["status"] = status
        }
        if canceled_barista_message != nil{
            mas["canceled_barista_message"] = canceled_barista_message
        }
        return mas
    }
}

class ElementProduct{
    var id : Int!
    var name : String!
    var product_type : Int!
    var img : String?
    var price : Int!
    var l_cup : Int!
    var m_cup : Int!
    var b_cup : Int!
    var active : Bool!
    var cups: [Int]?
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        name = mas["name"] as? String
        product_type = mas["product_type"] as? Int
        img = mas["img"] as? String
        price = mas["price"] as? Int
        l_cup = mas["l_cup"] as? Int
        m_cup = mas["m_cup"] as? Int
        b_cup = mas["b_cup"] as? Int
        active = mas["active"] as? Bool
        cups = mas["cups"] as? [Int]
    }
    
    func toPatch() -> [String : Any]{
        var mas = [String : Any]()
        if active != nil{
            mas["active"] = active
        }
    
        return mas
    }
}

class ElementUser{
    var id : Int!
    var first_name : String!
    var password : String!
    var username : String!
    
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        first_name = mas["first_name"] as? String
        password = mas["password"] as? String
        username = mas["username"] as? String
    }
}

class CupElement {
    var id : Int
    var size : Int
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        size = mas["size"] as! Int
    }
}

class Discount {
    var id : Int
    var discount_value : Int
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        discount_value = mas["discount_value"] as! Int
    }
}

struct IncomeElem {
    var id : Int
    var spot : Int
    var value : String
    var date : String
    var time : String
    
    var post: [String: Any]{
        return[
            "id": id,
            "spot": spot,
            "value": value,
            "date": date,
            "time": time
        ]
    }
}

struct InventoryElem {
    var id : Int
    var spot : Int
    var value : String
    var date : String
    var time : String
    var barista_name: String
    
    var post: [String: Any]{
        return[
            "id": id,
            "spot": spot,
            "value": value,
            "date": date,
            "time": time,
            "barista_name": barista_name
        ]
    }
}

struct OrderItemOfflineElem {
    var id : Int
    var order : Int
    var product : Int?
    var syrups : Int?
    var additionals : Int?
    var discount : Int
    var count : Int
    var cup : String
    var is_posted : Bool
    var time : String
    
    var post: [String: Any]{
        return[
            "id": id,
            "order": order,
            "product": product as Any,
            "syrups": syrups as Any,
            "additionals": additionals as Any,
            "discount": discount,
            "count": count,
            "cup": cup,
            "time": time
        ]
    }
}

struct OutcomeElem {
    var id : Int
    var spot : Int
    var income : Int?
    var price : Int
    var date : String
    var reason : String
    var time : String
    
    var post: [String: Any]{
        return[
            "id": id,
            "spot": spot,
            "income": income as Any,
            "price": price,
            "date": date,
            "reason": reason,
            "time": time
        ]
    }
}

struct ProductOutcomeElem {
    var id : Int
    var spot : Int
    var value : String
    var date : String
    var time : String
    
    var post: [String: Any]{
        return[
            "id": id,
            "spot": spot,
            "value": value,
            "date": date,
            "time": time
        ]
    }
}

struct ShiftElem {
    var id : Int
    var spot : Int
    var barista_name : String
    var date_start : String
    var date_finish : String
    var time_start : String
    var time_finish : String
    var cash : Int
    var card : Int
    
    var post: [String: Any]{
        return[
            "id": id,
            "spot": spot,
            "barista_name": barista_name,
            "date_start": date_start,
            "date_finish": date_finish,
            "time_start": time_start,
            "time_finish": time_finish,
            "cash": cash,
            "card": card
        ]
    }
}

struct OrderOffline{
    var id : Int!
    var user : Int!
    var username: String!
    var coffee_spot : Int!
    var full_price : Int!
    var date : String!
    var order_time : String!
    var status : Int!
    var cash_payment : Int!
    var card_payment : Int!
    var discount : Int!
    var is_posted : Bool!
    var list_pos : Int!
    
    var post: [String: Any]{
        return[
            "id": id,
            "user": user,
            "username": username,
            "coffee_spot": coffee_spot,
            "full_price": full_price,
            "date": date,
            "comment": "",
            "order_time": order_time,
            "status": status,
            "takeaway": false,
            "canceled_barista_message": "",
            "cash_payment": cash_payment,
            "card_payment": card_payment,
            "discount": discount
        ]
    }
}

class StorageItemElem {
    var id : Int
    var spot : Int
    var name : String
    var product_type : Int
    var type : String
    var barista_balance : Int?
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        spot = mas["spot"] as! Int
        name = mas["name"] as! String
        product_type = mas["product_type"] as! Int
        type = mas["type"] as! String
        barista_balance = mas["barista_balance"] as? Int
    }
}

class StorageItemType {
    var id : Int
    var name : String
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        name = mas["name"] as! String
    }
}

class AdditionalElem {
    var id : Int
    var name : String
    var price : Int
    var active : Bool?
    
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        price = mas["price"] as! Int
        name = mas["name"] as! String
        active = mas["is_active"] as? Bool
    }
}

class SyrupElem {
    var id : Int
    var name : String
    var price : Int
    var active : Bool?
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        price = mas["price"] as! Int
        name = mas["name"] as! String
        active = mas["is_active"] as? Bool
    }
}

class SpeciesElem {
    var id : Int
    var name : String
    
    init(mas: [String : Any]) {
        id = mas["id"] as! Int
        name = mas["name"] as! String
    }
}



struct ToJsonElem : Codable{
    var amount: Int
    var storage_item: Int
}

class GroupElem {
    var type: Int
    var img: String?
    
    init(type: Int, img: String?) {
        self.type = type
        self.img = img
    }
}

class CupSelectElem{
    var size: String!
    var price: Int!
    var action: () -> ()
    
    init(size: String, price: Int, action: @escaping () -> ()) {
        self.size = size
        self.price = price
        self.action = action
    }
}

class CashOrderItem {
    var product: ElementProduct?
    var syrup: SyrupElem?
    var additional: AdditionalElem?
    
    var cupSize : Int = 0
    var discount : Int = 0
    var count: Int = 1
    
    init(product: ElementProduct?,
         syrup: SyrupElem?,
         additional: AdditionalElem?,
         cupSize: Int, discount: Int, count: Int) {
        self.product = product
        self.additional = additional
        self.syrup = syrup
        self.cupSize = cupSize
        self.discount = discount
        self.count = count
    }
    
    func copy() -> CashOrderItem{
        fatalError()
    }
    
    func increase(){
        count += 1
    }
    
    func decrease(){
        if count > 1{
            count -= 1
        }
    }
    
    func setDiscount(value: Int){
        fatalError()
    }
    
    func getOrderItem(itemId: Int, orderID: Int) -> OrderItemOfflineElem{
        var cup: String!
        switch cupSize{
            case 1:
                cup = "l"
            case 2:
                cup = "m"
            case 3:
                cup = "b"
            default:
                cup = "default"
        }
        return OrderItemOfflineElem(id: itemId, order: orderID, product: product?.id, syrups: syrup?.id, additionals: additional?.id, discount: discount, count: count, cup: cup, is_posted: false, time: getTimeNow())
    }
    
    func getElemPrice() -> Int{
        fatalError("Subclasses need to implement the `sound()` method.")
    }
    
    func getSinglePrice() -> Int{
        fatalError("Subclasses need to implement the `sound()` method.")
    }
    
    func getDiscountValue() -> Int{
        fatalError("Subclasses need to implement the `sound()` method.")
    }
    
    func getDiscount() -> Int{
        fatalError("Subclasses need to implement the `sound()` method.")
    }
    
    func getName() -> String{
        fatalError("Subclasses need to implement the `sound()` method.")
    }
    
    func getCup() -> String{
        fatalError("Subclasses need to implement the `sound()` method.")
    }
    
    func equals(item: CashOrderItem) -> Bool{
        fatalError("Subclasses need to implement the `sound()` method.")
    }
}

class AdditionalOrderItem : CashOrderItem{
    override init(product: ElementProduct? = nil,
         syrup: SyrupElem? = nil,
         additional: AdditionalElem?,
         cupSize: Int = 0, discount: Int = 0, count: Int = 1) {
        super.init(product: product, syrup: syrup, additional: additional, cupSize: cupSize, discount: discount, count: count)
    }
    
    override func setDiscount(value: Int){
        discount = value
    }
    
    override func copy() -> CashOrderItem {
        return AdditionalOrderItem(product: product,
                             syrup: syrup,
                             additional: additional,
                             cupSize: cupSize,
                             discount: discount,
                             count: count)
    }
    
    override func getElemPrice() -> Int{
        return getSinglePrice() * count
    }
    
    override func getSinglePrice() -> Int{
        return (additional?.price)!
    }
    
    override func getDiscountValue() -> Int{
        if (getDiscount() == 0){
            return getElemPrice()
        }
        return getElemPrice() - getDiscount()
    }
    
    override func getDiscount() -> Int {
        print("DUDE \(Float(discount) / 100.0)")
        
        return Int(Float(getElemPrice()) * (1 - Float(discount) / 100.0))
    }
    
    override func getName() -> String{
        return additional!.name
    }
    
    override func getCup() -> String{
        return "-"
    }
    
    override func equals(item: CashOrderItem) -> Bool {
        return additional?.id == item.additional?.id
        && discount == item.discount
    }
}

class SyrupOrderItem : CashOrderItem{
    override init(product: ElementProduct? = nil,
                  syrup: SyrupElem?,
                  additional: AdditionalElem? = nil,
                  cupSize: Int = 0, discount: Int = 0, count: Int = 1) {
        super.init(product: product, syrup: syrup, additional: additional, cupSize: cupSize, discount: discount, count: count)
    }
    
    override func setDiscount(value: Int){
        discount = value
    }
    
    override func copy() -> CashOrderItem {
        return SyrupOrderItem(product: product,
                                   syrup: syrup,
                                   additional: additional,
                                   cupSize: cupSize,
                                   discount: discount,
                                   count: count)
    }
    
    override func getElemPrice() -> Int{
        return getSinglePrice() * count
    }
    
    override func getSinglePrice() -> Int{
        return (syrup?.price)!
    }
    
    override func getDiscountValue() -> Int{
        if (getDiscount() == 0){
            return getElemPrice()
        }
        return getElemPrice() - getDiscount()
    }
    
    override func getDiscount() -> Int {
        print("DUDE \(Float(discount) / 100.0)")
        
        return Int(Float(getElemPrice()) * (1 - Float(discount) / 100.0))
    }
    
    override func getName() -> String{
        return syrup!.name
    }
    
    override func getCup() -> String{
        return "-"
    }
    
    override func equals(item: CashOrderItem) -> Bool {
        return syrup?.id == item.syrup?.id
            && discount == item.discount
    }
}

class ProductOrderItem : CashOrderItem{
    override init(product: ElementProduct?,
                  syrup: SyrupElem? = nil,
                  additional: AdditionalElem? = nil,
                  cupSize: Int, discount: Int = 0, count: Int = 1) {
        super.init(product: product, syrup: syrup, additional: additional, cupSize: cupSize, discount: discount, count: count)
    }
    
    override func setDiscount(value: Int) {
        discount = value
    }
    
    override func copy() -> CashOrderItem {
        return ProductOrderItem(product: product,
                                   syrup: syrup,
                                   additional: additional,
                                   cupSize: cupSize,
                                   discount: discount,
                                   count: count)
    }
    
    override func getElemPrice() -> Int{
        return getSinglePrice() * count
    }
    
    override func getSinglePrice() -> Int{
        switch cupSize {
        case 1:
            return (product?.l_cup)!
        case 2:
            return (product?.m_cup)!
        case 3:
            return (product?.b_cup)!
        default:
            return (product?.price)!
        }
    }
    
    override func getDiscountValue() -> Int{
        if (getDiscount() == 0){
            return getElemPrice()
        }
        return getElemPrice() - getDiscount()
    }
    
    override func getDiscount() -> Int {
        print("DUDE \(Float(discount) / 100.0)")
    
        return Int(Float(getElemPrice()) * (1 - Float(discount) / 100.0))
    }
    
    override func getName() -> String{
        return product!.name
    }
    
    override func getCup() -> String{
        var size = "-"
        if (cupSize <= product!.cups!.count && cupSize != 0){
            let cupSizeValue = getCupSize(id: product!.cups![cupSize - 1])
            if (!cupSizeValue.isEmpty){
                size = "\(cupSizeValue) мл"
            } else{
                switch cupSize {
                case 1:
                    size = "S"
                    break
                case 2:
                    size = "M"
                    break
                case 3:
                    size = "L"
                    break
                default:
                    size = "-"
                    break
                }
            }
        } else if(cupSize == 0 && product!.cups!.count == 1){
            let cupSizeValue = getCupSize(id: product!.cups![cupSize])
            if (!cupSizeValue.isEmpty){
                size = "\(cupSizeValue) мл"
            }
        }
        return size
    }
    
    override func equals(item: CashOrderItem) -> Bool {
        return product?.id == item.product?.id
            && discount == item.discount && cupSize == item.cupSize
    }
}

class ElementCoffeeSpot{
    var id : Int!
    var company : Int!
    var max_order_limit : String!
    var cashbox: Bool!
    var coffee_go: Bool!
    var is_closed : Bool!
    
    init(mas: [String : Any]) {
        id = mas["id"] as? Int
        company = mas["name"] as? Int
        max_order_limit = mas["max_order_limit"] as? String
        cashbox = mas["cashbox"] as? Bool
        coffee_go = mas["coffee_go"] as? Bool
        is_closed = mas["is_closed"] as? Bool
    }
    
    func toPatch() -> [String : Any]{
        var mas = [String : Any]()
        if max_order_limit != nil{
            mas["max_order_limit"] = max_order_limit
        }
        if is_closed != nil{
            mas["is_closed"] = is_closed
        }
        return mas
    }
}
