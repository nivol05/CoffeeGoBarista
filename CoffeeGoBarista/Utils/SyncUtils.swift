//
//  SyncUtils.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 5/8/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import Foundation

class SyncUtils {
    
    private var inventoryTime: Int? = nil
    
    private var finishFunc: (() -> ()?)? = nil
    private var failFunc: (() -> ()?)? = nil
    
    class func startSync(){
        
    }
    
    private func checkInventory(isToPost: Bool){
        utilityQueue.async{
            let inventorys = db.getInventory()
            if !inventorys.isEmpty{
                if isToPost {
                    self.postInventory(elem: inventorys[0])
                } else {
                    self.inventoryTime = toMins(time: inventorys[0].time)
                    self.incomeCheck()
                }
            } else {
                if isToPost {
                    self.setSyncTime()
                    self.inventoryTime = nil
                } else {
                    self.incomeCheck()
                }
            }
        }
    }
    
    private func postInventory(elem: InventoryElem){
        utilityQueue.async {
            postInventorization(toPost: elem.post).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print(value)
                    db.delInventoryById(id: elem.id)
                    self.checkInventory(isToPost: false)
                    break
                case .failure(let error):
                    if self.failFunc != nil {
                        self.failFunc!()
                    }
                    print(error)
                    break
                }
            }
        }
    }
    
    private func incomeCheck(){
        utilityQueue.async {
            let incomes = db.getIncomes()
            if incomes.isEmpty{
                self.checkProductOutcomes()
                return
            }
            let outcomes = db.getOutcomes()
            self.postIncome(incomes: incomes, pos: 0, outcomes: outcomes)
        }
    }
    
    private func postIncome(incomes: [IncomeElem], pos: Int, outcomes: [OutcomeElem]){
        utilityQueue.async {
            if self.inventoryTime != nil{
                if pos == incomes.count{
                    self.checkProductOutcomes()
                    return
                } else {
                    if (toMins(time: incomes[pos].time) >= self.inventoryTime!){
                        self.postIncome(incomes: incomes, pos: pos + 1, outcomes: outcomes)
                        return
                    }
                }
            }
            
            postIncomes(toPost: incomes[pos].post).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print(value)
                    var updatedOutcome = outcomes.first(where: {$0.income == incomes[pos].id})
                    if (updatedOutcome != nil){
                        updatedOutcome!.income! = (value as! [String : Any])["id"] as! Int
                        db.updateOutcome(x: updatedOutcome!, lastId: updatedOutcome!.id)
                    }
                    
                    db.delIncomeById(id: incomes[pos].id)
                    if pos < incomes.count - 1{
                        self.postIncome(incomes: incomes, pos: pos + 1, outcomes: outcomes)
                    } else {
                        self.checkProductOutcomes()
                    }
                    
                    break
                case .failure(let error):
                    if self.failFunc != nil {
                        self.failFunc!()
                    }
                    print(error)
                    break
                }
            }
        }
    }
    
    private func checkProductOutcomes(){
        
    }
    
    private func setSyncTime(){
        
    }
}
