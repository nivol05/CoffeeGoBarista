//
//  CupUtils.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/20/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation

func getCupSize(id: Int) -> String{
    for x in db.getCups(){
        if x.id == id{
            return "\(x.size)"
        }
    }
    return ""
}

func getCupSizeInt(id: Int) -> Int{
    for x in db.getCups(){
        if x.id == id{
            return x.size
        }
    }
    return 0
}
