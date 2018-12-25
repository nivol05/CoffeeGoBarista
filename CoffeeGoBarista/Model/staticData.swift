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

func getProductsForType(type: Int) -> [ElementProduct]{
    var products = [ElementProduct]()
    for product in menu{
        if product.product_type == type{
            products.append(product)
        }
    }
    return products
}
