//
//  Network.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 10/26/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import Alamofire

let URL_GO = "http://138.68.79.98"
let ORDERS = "\(URL_GO)/api/customers/orders/"
let LOG_IN = "\(URL_GO)/api/customers/api-token-auth/"
let ORDER_ITEMS = "\(URL_GO)/api/customers/order_items/"
let PRODUCTS = "\(URL_GO)/api/customers/products/"

let COFFEE_SPOTS = "\(URL_GO)/api/customers/coffee_spots/"
let USER = "\(URL_GO)/api/customers/user/"
let FCM_DEV = "\(URL_GO)/api/customers/fcm_devices/"


var header : HTTPHeaders!

func getTokenAuth(user: [String : Any]) -> DataRequest{
    let link = "\(LOG_IN)"
    return Alamofire.request(link, method: .post , parameters: user, encoding: URLEncoding(), headers : nil)
}

func postFcmDevice(toPost: [String : Any]) -> DataRequest{
    let link = "\(FCM_DEV)"
    return Alamofire.request(link, method: .post , parameters: toPost, encoding: URLEncoding(), headers : header)
}

func checkBarista(username: String) -> DataRequest{
    let link = "\(COFFEE_SPOTS)?username=\(username)"
    return Alamofire.request(link, method: .get , parameters: nil, encoding: URLEncoding(), headers : header)
}

func patchSpotLimit(limit: String) -> DataRequest{
    let link = "\(COFFEE_SPOTS)\(current_coffee_spot.id!)/"
    let toPatch = ElementCoffeeSpot(mas: [String : Any]())
    toPatch.max_order_limit = limit
    return Alamofire.request(link, method: .patch , parameters: toPatch.toPatch(), encoding: URLEncoding(), headers : header)
}

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
