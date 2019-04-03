//
//  Network.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 10/26/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import Alamofire

let URL_GO = "https://coffeego.app"
let ORDERS = "\(URL_GO)/api/customers/orders/"
let LOG_IN = "\(URL_GO)/api/customers/api-token-auth/"
let ORDER_ITEMS = "\(URL_GO)/api/customers/order_items/"
let PRODUCTS = "\(URL_GO)/api/customers/products/"
let PRODUCT_TYPES_URL = "\(URL_GO)"
let SYRUPS_URL = "\(URL_GO)/api/customers/syrups/"
let SPECIES_URL = "\(URL_GO)/api/customers/species/"
let ADDITIONALS_URL = "\(URL_GO)/api/customers/additionals/"

let COFFEE_SPOTS = "\(URL_GO)/api/customers/coffee_spots/"
let USER = "\(URL_GO)/api/customers/user/"
let FCM_DEV = "\(URL_GO)/api/customers/fcm_devices/"
let CUPS = "\(URL_GO)/api/customers/cups/"
let DISCOUNTS = "\(URL_GO)/api/customers/discounts/"
let STORAGE_ITEMS = "\(URL_GO)/api/customers/storage_items/"
let INCOMES = "\(URL_GO)/api/customers/incomes/"
let PRODUCT_OUTCOMES = "\(URL_GO)/api/customers/product_outcomes/"
let INVENTORIZATIONS = "\(URL_GO)/api/customers/inventorizations/"
let ORDER_ITEMS_OFFLINE = "\(URL_GO)/api/customers/order_item_offline/"
let OUTCOMES = "\(URL_GO)/api/customers/outcomes/"
let SHIFTS = "\(URL_GO)/api/customers/shifts/"
let STORAGE_ITEM_PRODUCT_TYPE = "\(URL_GO)/api/customers/storage_item_product_type/"

var header : HTTPHeaders!


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


func getTokenAuth(user: [String : Any]) -> DataRequest{
    let link = "\(LOG_IN)"
    return Alamofire.request(link, method: .post , parameters: user, encoding: URLEncoding(), headers : nil)
}

func postFcmDevice(toPost: [String : Any]) -> DataRequest{
    let link = "\(FCM_DEV)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}

func postIncomes(toPost: [String : Any]) -> DataRequest{
    let link = "\(INCOMES)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}

func postOutcomes(toPost: [String : Any]) -> DataRequest{
    let link = "\(OUTCOMES)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}

func postProductOutcomes(toPost: [String : Any]) -> DataRequest{
    let link = "\(PRODUCT_OUTCOMES)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}

func postInventorization(toPost: [String : Any]) -> DataRequest{
    let link = "\(INVENTORIZATIONS)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}

func postOrderOffline(toPost: [String : Any]) -> DataRequest{
    let link = "\(ORDERS)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}

func postOrderItemsOffline(toPost: [String : Any]) -> DataRequest{
    let link = "\(ORDER_ITEMS_OFFLINE)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}

func postShifts(toPost: [String : Any]) -> DataRequest{
    let link = "\(SHIFTS)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}



func checkBarista(username: String) -> DataRequest{
    let link = "\(COFFEE_SPOTS)?username=\(username)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func patchSpotLimit(limit: String?, isClosed: Bool?) -> DataRequest{
    let link = "\(COFFEE_SPOTS)\(current_coffee_spot.id!)/"
    var toPatch = [String : Any]()
    if limit != nil{
        toPatch["max_order_limit"] = limit
    }
    if isClosed != nil{
        toPatch["is_closed"] = isClosed
    }
    return Alamofire.request(link, method: .patch , parameters: toPatch, encoding: URLEncoding(), headers : header)
}

func patchProduct(productId: Int, active: Bool) -> DataRequest{
    let link = "\(PRODUCTS)\(productId)/"
    var toPatch = [String : Any]()
    toPatch["active"] = active
    return Alamofire.request(link, method: .patch , parameters: toPatch, encoding: URLEncoding(), headers : header)
}

func patchShifts(id: Int, toPatch: [String : Any]) -> DataRequest{
    let link = "\(SHIFTS)\(id)/"
    return Alamofire.request(link, method: .patch , parameters: toPatch, encoding: URLEncoding(), headers : header)
}

func patchSpotSyncTime(id: Int, sync_time: String) -> DataRequest{
    let link = "\(COFFEE_SPOTS)\(id)/"
    var toPatch = [String : Any]()
    toPatch["sync_time"] = sync_time
    return Alamofire.request(link, method: .patch , parameters: toPatch, encoding: URLEncoding(), headers : header)
}
//func patchSpotLimit(limit: String) -> DataRequest{
//    let link = "\(COFFEE_SPOTS)\(current_coffee_spot.id!)/"
//    let toPatch = ElementCoffeeSpot(mas: [String : Any]())
//    toPatch.max_order_limit = limit
//    return Alamofire.request(link, method: .patch , parameters: toPatch.toPatch(), encoding: URLEncoding(), headers : header)
//}

//func patchProductActivity(active : Bool) -> DataRequest{
//    let link = "\(COFFEE_SPOTS)\(current_coffee_spot.id!)/"
//    let toPatch = ElementProduct(mas: [String : Any]())
//    toPatch.active = active
//    
//    return Alamofire.request(link, method: .patch , parameters: toPatch.toPatch(), encoding: URLEncoding(), headers : header)
//}

func getUsers(username: String) -> DataRequest{
    let link = "\(USER)?username=\(username)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func patchOrder(order: ElementOrder) -> DataRequest{
    let link = "\(ORDERS)\(order.id!)/"
    let toPatch = ElementOrder()
    toPatch.status = order.status
    toPatch.canceled_barista_message = order.canceled_barista_message
    return Alamofire.request(link, method: .patch , parameters: toPatch.toPatch(), encoding: URLEncoding(), headers : header)
}

func getProductsForSpot() -> DataRequest{
    let link = "\(PRODUCTS)?id=\(current_coffee_spot.id!)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getSyrupsForSpot(spotId : String) -> DataRequest{
    let url = "\(SYRUPS_URL)?id=\(spotId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getSpeciesForSpot(spotId : String) -> DataRequest{
    let url = "\(SPECIES_URL)?id=\(spotId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getAdditionalsForSpot(spotId : String) -> DataRequest{
    let url = "\(ADDITIONALS_URL)?id=\(spotId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getOrderItemsToOrder(orderId: Int) -> DataRequest{
    let link = "\(ORDER_ITEMS)?id=\(orderId)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getOrderById(orderId: Int) -> DataRequest{
    let link = "\(ORDERS)\(orderId)/"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getOrdersListOne() -> DataRequest{
    let link = "\(ORDERS)?list_1_coffee_spot_id=\(current_coffee_spot.id!)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getOrdersListTwo() -> DataRequest{
    let link = "\(ORDERS)?list_2_coffee_spot_id=\(current_coffee_spot.id!)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getOrdersCanceledClient() -> DataRequest{
    let link = "\(ORDERS)?list_3_coffee_spot_id=\(current_coffee_spot.id!)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getOrdersCanceledBarista() -> DataRequest{
    let link = "\(ORDERS)?list_4_coffee_spot_id=\(current_coffee_spot.id!)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getAllProductTypes() -> DataRequest{
    let url = "\(PRODUCT_TYPES_URL)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getCups(spotId: Int) -> DataRequest{
    let link = "\(CUPS)?spot_id=\(spotId)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getDiscounts(spotId: Int) -> DataRequest{
    let link = "\(DISCOUNTS)?spot_id=\(spotId)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getStorageItems(spotId: Int) -> DataRequest{
    let link = "\(STORAGE_ITEMS)?spot_id=\(spotId)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func getStorageItemsProductType(spotId: Int) -> DataRequest{
    let link = "\(STORAGE_ITEM_PRODUCT_TYPE)?spot_id=\(spotId)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

