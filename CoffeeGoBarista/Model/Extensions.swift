//
//  Extensions.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/20/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation

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
}
