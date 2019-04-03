
//
//  StringUtils.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation

class StringUtils {
    class func getSignedStr(text: String) -> String{
        return "\(text) ₴"
    }
    
    class func getDeSignedStr(text: String) -> String{
//        return String(text.split(separator: " ")[0])
        return String(text[text.startIndex..<text.index(text.endIndex, offsetBy: -2)])
    }
    
    class func getString(mas: [Int]) -> String{
        var result = ""
        if mas.isEmpty{
            return ""
        }
        for x in mas{
            result.append("\(x),")
        }
        return String(result[result.startIndex..<result.index(result.endIndex, offsetBy: -1)])
    }
    
    class func getIntArray(text: String) -> [Int]{
        var res = [Int]()
        if text.isEmpty{
            return res
        }
        for x in text.split(separator: ","){
            res.append(Int(x)!)
        }
        return res
    }
    
    class func toJsonString(elem: ToJsonElem) -> String {
        do{
            let jsonData = try JSONEncoder().encode(elem)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch{
            return ""
        }
    }
    
    class func toJsonString(elems: [ToJsonElem]) -> String {
        var result = "["
        for elem in elems{
            result.append("\(toJsonString(elem: elem)),")
        }
        return "\(String(result[result.startIndex..<result.index(result.endIndex, offsetBy: -1)]))]"
//        do{
//            let jsonData = try JSONSerialization.data(withJSONObject: strings, options: [])
//            return (String(data: jsonData, encoding: String.Encoding.utf8)!)
//        } catch{
//            return ""
//        }
    }
    
    class func getCashSelling(sells: [Int]) -> String{
        return "Наличные - \(getSignedStr(text: "\(sells[0])")), Карта - \(getSignedStr(text: "\(sells[1])"))"
    }
}
