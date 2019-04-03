//
//  TImeUtils.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/20/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation

var timerOn = false

func getTimeNow() -> String{
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH : mm"
    return formatter.string(from: today)
}

func toMins(time : String) -> Int{
    let minsMas = time.components(separatedBy: " : ")
    let hours = Int(minsMas[0])
    let minutes = Int(minsMas[1])
    return hours! * 60 + minutes!
}

func getTime(minutes: Int) -> String{
    var hour = minutes / 60
    hour = hour % 24
    let mins = minutes % 60
    
    var orderTime = ""
    if hour < 10 {
        orderTime.append("0")
    }
    orderTime.append("\(hour) : ")
    if mins < 10 {
        orderTime.append("0")
    }
    orderTime.append("\(mins)")
    return orderTime
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

func isDateInRange(startDate: String, endDate: String, checkDate: String) -> Bool{
    let startD = getDate(dateString: startDate)
    let endD = getDate(dateString: endDate)
    let checkD = getDate(dateString: checkDate)
    return (startD <= checkD && endD >= checkD) || (startD >= checkD && endD <= checkD)
}

func isDateAndTimeInRange(startDate: String, endDate: String, checkDate: String, startTime: Int, endTime: Int, checkTime: Int) -> Bool{
    let startD = getDate(dateString: startDate)
    let endD = getDate(dateString: endDate)
    let checkD = getDate(dateString: checkDate)
    return (checkD == startD && checkTime >= startTime) ||
    (checkD == endD && startD != endD && checkTime <= endTime) ||
    (checkD >= startD && checkD <= endD && startD != endD)
}

func getDate(dateString: String) -> Date{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.date(from: dateString)!
}

func getDateString(date: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: date)
}
