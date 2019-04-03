//
//  Database.swift
//  CofeeGo
//
//  Created by NI Vol on 9/27/18.
//  Copyright � 2018 Ni VoL. All rights reserved.
//

import Foundation
import SQLite

class DBBarista{
    
    var database : Connection!
    
    private let USER_TABLE = Table("user")//r
    private let TABLE_ORDERS_OFFLINE = Table("OrdersOffline")//r
    private let TABLE_ADDS = Table("all_additionals") //r
    private let TABLE_SYRUPS = Table("all_syrups")//r
    private let TABLE_SPECIES = Table("all_species")//r
    private let TABLE_PRODUCTS = Table("all_products")//r
    private let TABLE_DISCOUNTS = Table("Discounts")//r
    private let TABLE_INCOME = Table("Income")//r
    private let TABLE_STORAGE_ITEMS = Table("StorageItems")//r
    private let TABLE_INVENTORIZATION = Table("Inventorization")//r
    private let TABLE_ITEMS_OFFLINE = Table("Order_item_offline")//r
    private let TABLE_OUTCOME = Table("Outcome")//r
    private let TABLE_CUPS = Table("Cups")//r
    private let TABLE_SHIFTS = Table("TABLE_SHIFTS")//r
    private let TABLE_STORAGE_TYPES = Table("storage_types")//r
    private let TABLE_PRODUCT_OUTCOMES = Table("product_outcomes")//r
    private let TABLE_ORDERS_ONLINE = Table("OrdersOnline")
    
    private let ID = Expression<Int>("id")
    private let USER_FIRST_NAME = Expression<String>("first_name")
    private let USER_PASSWORD = Expression<String>("password")
    private let USER_USERNAME = Expression<String>("username")
    
    
    private let SPOT_ID = Expression<Int>("spot_id")
    private let BARISTA_NAME = Expression<String>("barista_name")
    private let USERNAME = Expression<String>("username")
    private let USER = Expression<Int>("user")
    private let FULL_PRICE = Expression<Int>("full_price")
    private let DATE = Expression<String>("date")
    private let ORDER_TIME = Expression<String>("order_time")
    private let STATUS = Expression<Int>("status")
    private let CASH_PAYMENT = Expression<Int>("cash_payment")
    private let CARD_PAYMENT = Expression<Int>("card_payment")
    private let NAME = Expression<String>("name")
    private let PRICE = Expression<Int>("price")
    private let TYPE = Expression<String>("type")
    private let IMG = Expression<String?>("img")
    private let L_CUP = Expression<Int>("l_cup")
    private let M_CUP = Expression<Int>("m_cup")
    private let B_CUP = Expression<Int>("b_cup")
    private let ACTIVE = Expression<Int>("active")
    private let CUPS = Expression<String>("cups")
    private let VALUE = Expression<String>("value")
    private let COMMENT = Expression<String>("comment")
    private let TAKEAWAY = Expression<Int>("takeaway")
    private let BARISTA_BALANCE = Expression<Int?>("barista_balance")
    private let ORDER_ID = Expression<Int>("order_id")
    private let CUP = Expression<String>("cup")
    private let SYRUP = Expression<Int?>("syrup")
    private let ADDITIONAL = Expression<Int?>("additional")
    private let DISCOUNT = Expression<Int>("discount")
    private let COUNT = Expression<Int>("count")
    private let INCOME_ID = Expression<Int?>("income_id")
    private let REASON = Expression<String>("reason")
    private let SIZE = Expression<Int>("size")
    private let DATE_START = Expression<String>("date_start")
    private let DATE_FINISH = Expression<String>("date_finish")
    private let TIME_START = Expression<String>("time_start")
    private let TIME_FINISH = Expression<String>("time_finish")
    private let LIST_POS = Expression<Int>("list_pos")
    private let IS_POSTED = Expression<Int>("is_posted")
    private let PRODUCT_ID = Expression<Int?>("product_id")
    private let TIME = Expression<String>("time")
    private let PRODUCT_TYPE = Expression<Int>("product_type")
    
    
    init() {
        do{
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("coffeeGo").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    private func createTableUser(){
        let createTable = self.USER_TABLE.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.USER_FIRST_NAME)
            table.column(self.USER_USERNAME)
            table.column(self.USER_PASSWORD)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableOrdersOffline(){
        let createTable = self.TABLE_ORDERS_OFFLINE.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.USER)
            table.column(self.SPOT_ID)
            table.column(self.FULL_PRICE)
            table.column(self.DATE)
            table.column(self.ORDER_TIME)
            table.column(self.USERNAME)
            table.column(self.CASH_PAYMENT)
            table.column(self.CARD_PAYMENT)
            table.column(self.IS_POSTED)
            table.column(self.LIST_POS)
            table.column(self.DISCOUNT)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableOrdersOnline(){
        let createTable = self.TABLE_ORDERS_ONLINE.create{ (table) in
            table.column(self.ID, primaryKey: true)
//            table.column(self.USER)
//            table.column(self.SPOT_ID)
            table.column(self.COMMENT)
            table.column(self.TAKEAWAY)
            table.column(self.FULL_PRICE)
            table.column(self.DATE)
            table.column(self.ORDER_TIME)
            table.column(self.USERNAME)
            table.column(self.CASH_PAYMENT)
            table.column(self.CARD_PAYMENT)
            table.column(self.IS_POSTED)
            table.column(self.LIST_POS)
            table.column(self.DISCOUNT)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableOrderItemsOffline(){
        let createTable = self.TABLE_ITEMS_OFFLINE.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.ORDER_ID)
            table.column(self.PRODUCT_ID)
            table.column(self.CUP)
            table.column(self.SYRUP)
            table.column(self.ADDITIONAL)
            table.column(self.DISCOUNT)
            table.column(self.COUNT)
            table.column(self.IS_POSTED)
            table.column(self.TIME)
            table.column(self.LIST_POS)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableShifts(){
        let createTable = self.TABLE_SHIFTS.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.BARISTA_NAME)
            table.column(self.DATE_START)
            table.column(self.DATE_FINISH)
            table.column(self.TIME_START)
            table.column(self.TIME_FINISH)
            table.column(self.CASH_PAYMENT)
            table.column(self.CARD_PAYMENT)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableInventorization(){
        let createTable = self.TABLE_INVENTORIZATION.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.SPOT_ID)
            table.column(self.DATE)
            table.column(self.VALUE)
            table.column(self.TIME)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableIncome(){
        let createTable = self.TABLE_INCOME.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.SPOT_ID)
            table.column(self.DATE)
            table.column(self.VALUE)
            table.column(self.TIME)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableOutcome(){
        let createTable = self.TABLE_OUTCOME.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.INCOME_ID)
            table.column(self.DATE)
            table.column(self.PRICE)
            table.column(self.REASON)
            table.column(self.TIME)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableProductOutcome(){
        let createTable = self.TABLE_PRODUCT_OUTCOMES.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.SPOT_ID)
            table.column(self.DATE)
            table.column(self.VALUE)
            table.column(self.TIME)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableStorageItems(){
        let createTable = self.TABLE_STORAGE_ITEMS.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.SPOT_ID)
            table.column(self.NAME)
            table.column(self.TYPE)
            table.column(self.BARISTA_BALANCE)
            table.column(self.PRODUCT_TYPE)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableStorageTypes(){
        let createTable = self.TABLE_STORAGE_TYPES.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.NAME)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableCups(){
        let createTable = self.TABLE_CUPS.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.SIZE)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableDiscounts(){
        let createTable = self.TABLE_DISCOUNTS.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.DISCOUNT)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableAdds(){
        let createTable = self.TABLE_ADDS.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.NAME)
            table.column(self.PRICE)
            table.column(self.ACTIVE)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    
    private func createTableProduct(){
        let createTable = self.TABLE_PRODUCTS.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.NAME)
            table.column(self.PRODUCT_TYPE)
            table.column(self.IMG)
            table.column(self.PRICE)
            table.column(self.L_CUP)
            table.column(self.M_CUP)
            table.column(self.B_CUP)
            table.column(self.ACTIVE)
            table.column(self.CUPS)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }

    
    private func createTableSyrups(){
        let createTable = self.TABLE_SYRUPS.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.NAME)
            table.column(self.PRICE)
            table.column(self.ACTIVE)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    private func createTableSpecies(){
        let createTable = self.TABLE_SPECIES.create{ (table) in
            table.column(self.ID, primaryKey: true)
            table.column(self.NAME)
        
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    //USER
    func setUser(user: ElementUser){
        
        createTableUser()
        
        let insertUser = self.USER_TABLE.insert(
            self.ID <- user.id,
            self.USER_FIRST_NAME <- user.first_name,
            self.USER_USERNAME <- user.username,
            self.USER_PASSWORD <- user.password
        )
        
        do{
            try self.database.run(insertUser)
            print("Inserted")
        } catch{
            print(error)
            print("Not inserted")
        }
    }
    
    func getUser() -> ElementUser?{
        let select = USER_TABLE.select([
            ID,
            USER_FIRST_NAME,
            USER_USERNAME,
            USER_PASSWORD
            ])
        do{
            let users = try self.database.prepare(select)
            for user in users{
                var elem = [String : Any]()
                elem["id"] = user[self.ID]
                elem["first_name"] = user[self.USER_FIRST_NAME]
                elem["username"] = user[self.USER_USERNAME]
                elem["password"] = user[self.USER_PASSWORD]
                
                return ElementUser(mas: elem)
            }
        } catch{
            print(error)
        }
        
        return nil
    }
    
    func delUser(){
        let del = self.USER_TABLE.delete()
        do {
            try self.database.run(del)
        } catch {
            print(error)
        }
    }
    
    
    //CUPS
    func setCups(list: [CupElement]){
        delCups()
        createTableCups()
        do{
            try database.transaction{
                for x in list{
                    let insert = self.TABLE_CUPS.insert(
                        self.ID <- x.id,
                        self.SIZE <- x.size
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        } catch{
            print("Database \(error)")
        }
    }
    
    func getCups() -> [CupElement]{
        var response = [CupElement]()
        do{
            try database.transaction{
                let select = TABLE_CUPS.select([
                    ID,
                    SIZE
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        var elem = [String : Any]()
                        elem["id"] = item[self.ID]
                        elem["size"] = item[self.SIZE]
                        
                        response.append(CupElement(mas: elem))
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }

    func delCups(){
        let del = self.TABLE_CUPS.delete()
        do {
            try self.database.run(del)
        } catch {
            print(error)
        }
    }
    
    
    //DISCOUNTS
    func setDiscounts(list: [Discount]){
        delDiscounts()
        createTableDiscounts()
        do{
            try database.transaction{
                for x in list{
                    let insert = self.TABLE_DISCOUNTS.insert(
                        self.ID <- x.id,
                        self.DISCOUNT <- x.discount_value
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        } catch{
            print("Database \(error)")
        }
    }
    
    func getDiscounts() -> [Discount]{
        var response = [Discount]()
        do{
            try database.transaction{
                let select = TABLE_DISCOUNTS.select([
                    ID,
                    DISCOUNT
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        var elem = [String : Any]()
                        elem["id"] = item[self.ID]
                        elem["discount_value"] = item[self.DISCOUNT]
                        response.append(Discount(mas: elem))
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    func delDiscounts(){
        let del = self.TABLE_DISCOUNTS.delete()
        do {
            try self.database.run(del)
        } catch {
            print(error)
        }
    }
    
    
    //ADDS
    func delAdds() {
        let del = self.TABLE_ADDS.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    func setAdds(list: [AdditionalElem]){
        delAdds()
        createTableAdds()
        do{
            try database.transaction{
                for x in list{
                    let insert = self.TABLE_ADDS.insert(
                        self.ID <- x.id,
                        self.NAME <- x.name,
                        self.PRICE <- x.price,
                        self.ACTIVE <- x.active.hashValue
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        } catch{
            print("Database \(error)")
        }
    }
    
    func getAdds() -> [AdditionalElem]{
        var response = [AdditionalElem]()
        do{
            try database.transaction{
                let select = TABLE_ADDS.select([
                    ID,
                    NAME,
                    PRICE,
                    ACTIVE
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        var elem = [String : Any]()
                        elem["id"] = item[self.ID]
                        elem["name"] = item[self.NAME]
                        elem["price"] = item[self.PRICE]
                        elem["is_active"] = item[self.ACTIVE] == 1
                        
                        response.append(AdditionalElem(mas: elem))
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func delSyrups() {
        let del = self.TABLE_SYRUPS.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    func setSyrups(list: [SyrupElem]){
        delSyrups()
        createTableSyrups()
        do{
            try database.transaction{
                for x in list{
                    let insert = self.TABLE_SYRUPS.insert(
                        self.ID <- x.id,
                        self.NAME <- x.name,
                        self.PRICE <- x.price,
                        self.ACTIVE <- x.active.hashValue
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        } catch{
            print("Database \(error)")
        }
    }
    
    func getSyrups() -> [SyrupElem]{
        var response = [SyrupElem]()
        do{
            try database.transaction{
                let select = TABLE_SYRUPS.select([
                    ID,
                    NAME,
                    PRICE,
                    ACTIVE
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        var elem = [String : Any]()
                        elem["id"] = item[self.ID]
                        elem["name"] = item[self.NAME]
                        elem["price"] = item[self.PRICE]
                        elem["is_active"] = item[self.ACTIVE] == 1
                        
                        response.append(SyrupElem(mas: elem))
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    
    
    //SPECIES
    func delSpecies() {
        let del = self.TABLE_SPECIES.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    func setSpecies(list: [SpeciesElem]){
        delSpecies()
        createTableSpecies()
        do{
            try database.transaction{
                for x in list{
                    let insert = self.TABLE_SPECIES.insert(
                        self.ID <- x.id,
                        self.NAME <- x.name
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        } catch{
            print("Database \(error)")
        }
    }
    
    func getSpecies() -> [SpeciesElem]{
        var response = [SpeciesElem]()
        do{
            try database.transaction{
                let select = TABLE_SPECIES.select([
                    ID,
                    NAME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        var elem = [String : Any]()
                        elem["id"] = item[self.ID]
                        elem["name"] = item[self.NAME]
                        
                        response.append(SpeciesElem(mas: elem))
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    //PRODUCTS
    func delProducts() {
        let del = self.TABLE_PRODUCTS.drop(ifExists: true)
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    func setProducts(list: [ElementProduct]){
        delProducts()
        createTableProduct()
        do{
            try database.transaction{
                for x in list{
                    let insert = self.TABLE_PRODUCTS.insert(
                        self.ID <- x.id,
                        self.NAME <- x.name,
                        self.PRODUCT_TYPE <- x.product_type,
                        self.IMG <- x.img,
                        self.PRODUCT_TYPE <- x.product_type,
                        self.PRICE <- x.price,
                        self.L_CUP <- x.l_cup,
                        self.M_CUP <- x.m_cup,
                        self.B_CUP <- x.b_cup,
                        self.ACTIVE <- x.active.hashValue,
                        self.CUPS <- StringUtils.getString(mas: x.cups!)
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        } catch{
            print("Database \(error)")
        }
    }
    
    func getProducts() -> [ElementProduct]{
        var response = [ElementProduct]()
        do{
            try database.transaction{
                let select = TABLE_PRODUCTS.select([
                    ID,
                    NAME,
                    PRODUCT_TYPE,
                    IMG,
                    PRICE,
                    L_CUP,
                    M_CUP,
                    B_CUP,
                    ACTIVE,
                    CUPS
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        var elem = [String : Any]()
                        elem["id"] = item[self.ID]
                        elem["name"] = item[self.NAME]
                        elem["product_type"] = item[self.PRODUCT_TYPE]
                        elem["img"] = item[self.IMG]
                        elem["price"] = item[self.PRICE]
                        elem["l_cup"] = item[self.L_CUP]
                        elem["m_cup"] = item[self.M_CUP]
                        elem["b_cup"] = item[self.B_CUP]
                        elem["active"] = item[self.ACTIVE] == 1
                        elem["cups"] = StringUtils.getIntArray(text: item[self.CUPS])
                        
                        response.append(ElementProduct(mas: elem))
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    //INCOMES
    func delIncomes() {
        let del = self.TABLE_INCOME.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func delIncomeById(id: Int) {
        let del = self.TABLE_INCOME.filter(self.ID == id).delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func setIncomes(x: IncomeElem){
        createTableIncome()
        do{
            try database.transaction{
                let insert = self.TABLE_INCOME.insert(
                    self.ID <- x.id,
                    self.SPOT_ID <- x.spot,
                    self.VALUE <- x.value,
                    self.DATE <- x.date,
                    self.TIME <- x.time
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func getIncomes() -> [IncomeElem]{
        var response = [IncomeElem]()
        do{
            try database.transaction{
                let select = TABLE_INCOME.select([
                    ID,
                    SPOT_ID,
                    VALUE,
                    DATE,
                    TIME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(IncomeElem(
                            id: item[self.ID],
                            spot : item[self.SPOT_ID] ,
                            value : item[self.VALUE] ,
                            date : item[self.DATE] ,
                            time : item[self.TIME]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func getLastIncomeId() -> Int{
        var response : Int = 0
        do{
            try database.transaction{
                let select = TABLE_INCOME.order(ID.desc).select([
                    ID
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        response = item[self.ID]
                        break
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch {
            print("Database \(error)")
        }
        
        return response
    }
    
    //ProductOutcomes
    func delProdOutcomes() {
        let del = self.TABLE_PRODUCT_OUTCOMES.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func delProductOutcomeById(id: Int) {
        let del = self.TABLE_PRODUCT_OUTCOMES.filter(self.ID == id).delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func setProductOutcome(x: ProductOutcomeElem){
        createTableProductOutcome()
        do{
            try database.transaction{
                let insert = self.TABLE_PRODUCT_OUTCOMES.insert(
                    self.ID <- x.id,
                    self.SPOT_ID <- x.spot,
                    self.VALUE <- x.value,
                    self.DATE <- x.date,
                    self.TIME <- x.time
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func getProductOutcomes() -> [ProductOutcomeElem]{
        var response = [ProductOutcomeElem]()
        do{
            try database.transaction{
                let select = TABLE_PRODUCT_OUTCOMES.select([
                    ID,
                    SPOT_ID,
                    VALUE,
                    DATE,
                    TIME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(ProductOutcomeElem(
                            id: item[self.ID],
                            spot : item[self.SPOT_ID] ,
                            value : item[self.VALUE] ,
                            date : item[self.DATE] ,
                            time : item[self.TIME]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    //Outcomes
    func delOutcomes() {
        let del = self.TABLE_OUTCOME.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func delOutcomeById(id: Int) {
        let del = self.TABLE_OUTCOME.filter(self.ID == id).delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func setOutcome(x: OutcomeElem){
        createTableOutcome()
        do{
            try database.transaction{
                let insert = self.TABLE_OUTCOME.insert(
                    self.ID <- x.id,
                    self.SPOT_ID <- x.spot,
                    self.INCOME_ID <- x.income,
                    self.PRICE <- x.price,
                    self.DATE <- x.date,
                    self.REASON <- x.reason,
                    self.TIME <- x.time
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func updateOutcome(x: OutcomeElem, lastId: Int){
        do{
            try database.transaction{
                let insert = self.TABLE_OUTCOME.filter(ID == lastId).update(
                    self.ID <- x.id,
                    self.SPOT_ID <- x.spot,
                    self.INCOME_ID <- x.income,
                    self.PRICE <- x.price,
                    self.DATE <- x.date,
                    self.REASON <- x.reason,
                    self.TIME <- x.time
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func getOutcomes() -> [OutcomeElem]{
        var response = [OutcomeElem]()
        do{
            try database.transaction{
                let select = TABLE_OUTCOME.select([
                    ID,
                    SPOT_ID,
                    INCOME_ID,
                    PRICE,
                    DATE,
                    REASON,
                    TIME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(OutcomeElem(
                            id: item[self.ID],
                            spot : item[self.SPOT_ID] ,
                            income : item[self.INCOME_ID] ,
                            price : item[self.PRICE],
                            date : item[self.DATE] ,
                            reason : item[self.REASON],
                            time : item[self.TIME]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    //Inventory
    func delInventory() {
        let del = self.TABLE_INVENTORIZATION.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func delInventoryById(id: Int) {
        let del = self.TABLE_INVENTORIZATION.filter(self.ID == id).delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func setInventory(x: InventoryElem){
        createTableInventorization()
        do{
            try database.transaction{
                let insert = self.TABLE_INVENTORIZATION.insert(
                    self.ID <- x.id,
                    self.SPOT_ID <- x.spot,
                    self.VALUE <- x.value,
                    self.DATE <- x.date,
                    self.TIME <- x.time,
                    self.BARISTA_NAME <- x.barista_name
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func getInventory() -> [InventoryElem]{
        var response = [InventoryElem]()
        do{
            try database.transaction{
                let select = TABLE_INVENTORIZATION.select([
                    ID,
                    SPOT_ID,
                    VALUE,
                    DATE,
                    TIME,
                    BARISTA_NAME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(InventoryElem(
                            id: item[self.ID],
                            spot : item[self.SPOT_ID] ,
                            value : item[self.VALUE] ,
                            date : item[self.DATE] ,
                            time : item[self.TIME],
                            barista_name : item[self.BARISTA_NAME]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    //ORderItemsOffline
    func delItemsOffline() {
        let del = self.TABLE_ITEMS_OFFLINE.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func getItemsOfflineSize() -> Int {
        var size = 0
        let count = self.TABLE_ITEMS_OFFLINE.count
        do {
            size = try database.scalar(count)
        } catch {
            print(error)
        }
        return size
    }
    
    func setItemsOffline(items: [OrderItemOfflineElem]){
        createTableOrderItemsOffline()
        do{
            try database.transaction{
                for x in items{
                    let insert = self.TABLE_ITEMS_OFFLINE.insert(
                        self.ID <- x.id,
                        self.ORDER_ID <- x.order,
                        self.PRODUCT_ID <- x.product,
                        self.SYRUP <- x.syrups,
                        self.ADDITIONAL <- x.additionals,
                        self.DISCOUNT <- x.discount,
                        self.COUNT <- x.count,
                        self.CUP <- x.cup,
                        self.IS_POSTED <- x.is_posted.hashValue,
                        self.TIME <- x.time
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func updateItemOffline(x: OrderItemOfflineElem, lastId: Int){
        do{
            try database.transaction{
                let insert = self.TABLE_ITEMS_OFFLINE.filter(self.ID == lastId).update(
                    self.ID <- x.id,
                    self.ORDER_ID <- x.order,
                    self.PRODUCT_ID <- x.product,
                    self.SYRUP <- x.syrups,
                    self.ADDITIONAL <- x.additionals,
                    self.DISCOUNT <- x.discount,
                    self.COUNT <- x.count,
                    self.CUP <- x.cup,
                    self.IS_POSTED <- x.is_posted.hashValue,
                    self.TIME <- x.time
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func getItemsOffline() -> [OrderItemOfflineElem]{
        var response = [OrderItemOfflineElem]()
        do{
            try database.transaction{
                let select = TABLE_ITEMS_OFFLINE.select([
                    ID,
                    ORDER_ID,
                    PRODUCT_ID,
                    SYRUP,
                    ADDITIONAL,
                    DISCOUNT,
                    COUNT,
                    CUP,
                    IS_POSTED,
                    TIME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(OrderItemOfflineElem(
                            id: item[self.ID],
                            order : item[self.ORDER_ID] ,
                            product : item[self.PRODUCT_ID] ,
                            syrups : item[self.SYRUP] ,
                            additionals : item[self.ADDITIONAL],
                            discount : item[self.DISCOUNT],
                            count : item[self.COUNT],
                            cup : item[self.CUP],
                            is_posted : item[self.IS_POSTED] == 1,
                            time : item[self.TIME]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func getItemsOfflineForOrder(id: Int) -> [OrderItemOfflineElem]{
        var response = [OrderItemOfflineElem]()
        do{
            try database.transaction{
                let select = TABLE_ITEMS_OFFLINE.filter(ORDER_ID == id).select([
                    ID,
                    ORDER_ID,
                    PRODUCT_ID,
                    SYRUP,
                    ADDITIONAL,
                    DISCOUNT,
                    COUNT,
                    CUP,
                    IS_POSTED,
                    TIME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(OrderItemOfflineElem(
                            id: item[self.ID],
                            order : item[self.ORDER_ID] ,
                            product : item[self.PRODUCT_ID] ,
                            syrups : item[self.SYRUP] ,
                            additionals : item[self.ADDITIONAL],
                            discount : item[self.DISCOUNT],
                            count : item[self.COUNT],
                            cup : item[self.CUP],
                            is_posted : item[self.IS_POSTED] == 1,
                            time : item[self.TIME]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func getItemsOfflineNotPosted() -> [OrderItemOfflineElem]{
        var response = [OrderItemOfflineElem]()
        do{
            try database.transaction{
                let select = TABLE_ITEMS_OFFLINE.filter(IS_POSTED == 0).select([
                    ID,
                    ORDER_ID,
                    PRODUCT_ID,
                    SYRUP,
                    ADDITIONAL,
                    DISCOUNT,
                    COUNT,
                    CUP,
                    IS_POSTED,
                    TIME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(OrderItemOfflineElem(
                            id: item[self.ID],
                            order : item[self.ORDER_ID] ,
                            product : item[self.PRODUCT_ID] ,
                            syrups : item[self.SYRUP] ,
                            additionals : item[self.ADDITIONAL],
                            discount : item[self.DISCOUNT],
                            count : item[self.COUNT],
                            cup : item[self.CUP],
                            is_posted : item[self.IS_POSTED] == 1,
                            time : item[self.TIME]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    //Shift
    func delShifts() {
        let del = self.TABLE_SHIFTS.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func delShiftById(id: Int) {
        let del = self.TABLE_SHIFTS.filter(self.ID == id).delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func setShift(x: ShiftElem){
        delShifts()
        createTableShifts()
        do{
            try database.transaction{
               
                let insert = self.TABLE_SHIFTS.insert(
                    self.ID <- x.id,
                    self.SPOT_ID <- x.spot,
                    self.BARISTA_NAME <- x.barista_name,
                    self.DATE_START <- x.date_start,
                    self.DATE_FINISH <- x.date_finish,
                    self.TIME_START <- x.time_start,
                    self.TIME_FINISH <- x.time_finish,
                    self.CASH_PAYMENT <- x.cash,
                    self.CARD_PAYMENT <- x.card
                )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        catch{
            print("Database \(error)")
        }
    }
    
    func getShifts() -> [ShiftElem]{
        var response = [ShiftElem]()
        do{
            try database.transaction{
                let select = TABLE_ITEMS_OFFLINE.select([
                    ID,
                    SPOT_ID,
                    BARISTA_NAME,
                    DATE_START,
                    DATE_FINISH,
                    TIME_START,
                    TIME_FINISH,
                    CASH_PAYMENT,
                    CARD_PAYMENT
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(ShiftElem(
                            id: item[self.ID],
                            spot : item[self.SPOT_ID] ,
                            barista_name : item[self.BARISTA_NAME] ,
                            date_start : item[self.DATE_START] ,
                            date_finish : item[self.DATE_FINISH],
                            time_start : item[self.TIME_START],
                            time_finish : item[self.TIME_FINISH],
                            cash : item[self.CASH_PAYMENT],
                            card : item[self.CARD_PAYMENT]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    //OrdersOnline
    
    func delOrdersOnline() {
        let del = self.TABLE_ORDERS_ONLINE.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    
    func setOrderOnline(x: ElementOrder){
        createTableOrdersOnline()
        do{
            try database.transaction{
                
                let insert = self.TABLE_ORDERS_ONLINE.insert(
                    self.ID <- x.id,
//                    self.USER <- x.user,
                    self.USERNAME <- x.username,
//                    self.SPOT_ID <- x.coffee_spot,
                    self.FULL_PRICE <- x.full_price,
                    self.DATE <- x.date,
                    self.ORDER_TIME <- x.order_time,
                    self.STATUS <- x.status,
                    self.CASH_PAYMENT <- x.cash_payment,
                    self.CARD_PAYMENT <- x.card_payment,
                    self.DISCOUNT <- x.discount,
                    self.TAKEAWAY <- x.takeaway.hashValue,
                    self.COMMENT <- x.comment
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func setOrdersOnline(elems: [ElementOrder]){
        createTableOrdersOnline()
        do{
            try database.transaction{
                
                for x in elems{
                    let insert = self.TABLE_ORDERS_ONLINE.insert(
                        self.ID <- x.id,
                        //                    self.USER <- x.user,
                        self.USERNAME <- x.username,
                        //                    self.SPOT_ID <- x.coffee_spot,
                        self.FULL_PRICE <- x.full_price,
                        self.DATE <- x.date,
                        self.ORDER_TIME <- x.order_time,
                        self.STATUS <- x.status,
                        self.CASH_PAYMENT <- x.cash_payment,
                        self.CARD_PAYMENT <- x.card_payment,
                        self.DISCOUNT <- x.discount,
                        self.TAKEAWAY <- x.takeaway.hashValue,
                        self.COMMENT <- x.comment
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func getOrdersOnline() -> [ElementOrder]{
        var response = [ElementOrder]()
        do{
            try database.transaction{
                let select = TABLE_ORDERS_ONLINE.select([
                    ID,
                    USERNAME,
                    FULL_PRICE,
                    DATE,
                    ORDER_TIME,
                    STATUS,
                    CASH_PAYMENT,
                    CARD_PAYMENT,
                    DISCOUNT,
                    COMMENT,
                    TAKEAWAY
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(ElementOrder(mas: [
                            "id": item[self.ID],
                            "username" : item[self.USERNAME] ,
                            "full_price" : item[self.FULL_PRICE],
                            "date" : item[self.DATE],
                            "order_time" : item[self.ORDER_TIME],
                            "status" : item[self.STATUS],
                            "cash_payment" : item[self.CASH_PAYMENT],
                            "card_payment" : item[self.CARD_PAYMENT],
                            "discount" : item[self.DISCOUNT],
                            "takeaway" : item[self.TAKEAWAY] == 1,
                            "comment" : item[self.COMMENT]
                        ]))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func getOrdersOnlineForDates(startDate: String, endDate: String) -> [ElementOrder]{
        var response = [ElementOrder]()
        do{
            try database.transaction{
                let select = TABLE_ORDERS_ONLINE.select([
                    ID,
                    USERNAME,
                    FULL_PRICE,
                    DATE,
                    ORDER_TIME,
                    STATUS,
                    CASH_PAYMENT,
                    CARD_PAYMENT,
                    DISCOUNT,
                    COMMENT,
                    TAKEAWAY
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        if(isDateInRange(startDate: startDate, endDate: endDate, checkDate: item[self.DATE])){
                            response.append(ElementOrder(mas: [
                                "id": item[self.ID],
                                "username" : item[self.USERNAME] ,
                                "full_price" : item[self.FULL_PRICE],
                                "date" : item[self.DATE],
                                "order_time" : item[self.ORDER_TIME],
                                "status" : item[self.STATUS],
                                "cash_payment" : item[self.CASH_PAYMENT],
                                "card_payment" : item[self.CARD_PAYMENT],
                                "discount" : item[self.DISCOUNT],
                                "takeaway" : item[self.TAKEAWAY] == 1,
                                "comment" : item[self.COMMENT]
                                ]))
                        }
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func getOrdersOnlineForShift(startDate: String, endDate: String, shiftStartTime: Int) -> [ElementOrder]{
        var response = [ElementOrder]()
        do{
            try database.transaction{
                let select = TABLE_ORDERS_ONLINE.select([
                    ID,
                    USERNAME,
                    FULL_PRICE,
                    DATE,
                    ORDER_TIME,
                    STATUS,
                    CASH_PAYMENT,
                    CARD_PAYMENT,
                    DISCOUNT,
                    COMMENT,
                    TAKEAWAY
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        if(isDateAndTimeInRange(startDate: startDate,
                                                endDate: endDate,
                                                checkDate: item[self.DATE],
                                                startTime: shiftStartTime,
                                                endTime: toMins(time: getTimeNow()),
                                                checkTime: toMins(time: item[self.ORDER_TIME]))
                            ){
                            response.append(ElementOrder(mas: [
                                "id": item[self.ID],
                                "username" : item[self.USERNAME] ,
                                "full_price" : item[self.FULL_PRICE],
                                "date" : item[self.DATE],
                                "order_time" : item[self.ORDER_TIME],
                                "status" : item[self.STATUS],
                                "cash_payment" : item[self.CASH_PAYMENT],
                                "card_payment" : item[self.CARD_PAYMENT],
                                "discount" : item[self.DISCOUNT],
                                "takeaway" : item[self.TAKEAWAY] == 1,
                                "comment" : item[self.COMMENT]
                                ]))
                        }
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    //OrdersOffline
    func delOrdersOffline() {
        let del = self.TABLE_ORDERS_OFFLINE.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    
    func getOrdersOfflineSize() -> Int {
        var size = 0
        let count = self.TABLE_ORDERS_OFFLINE.count
        do{
            size = try database.scalar(count)
        } catch {
            print(error)
        }
        return size
    }
    
    func setOrderOffline(x: OrderOffline){
        createTableOrdersOffline()
        do{
            try database.transaction{
                
                let insert = self.TABLE_ORDERS_OFFLINE.insert(
                    self.ID <- x.id,
                    self.USER <- x.user,
                    self.USERNAME <- x.username,
                    self.SPOT_ID <- x.coffee_spot,
                    self.FULL_PRICE <- x.full_price,
                    self.DATE <- x.date,
                    self.ORDER_TIME <- x.order_time,
                    self.STATUS <- x.status,
                    self.CASH_PAYMENT <- x.cash_payment,
                    self.CARD_PAYMENT <- x.card_payment,
                    self.DISCOUNT <- x.discount,
                    self.IS_POSTED <- x.is_posted.hashValue,
                    self.LIST_POS <- x.list_pos
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func updateOrderOffline(x: OrderOffline, lastId: Int){
        do{
            try database.transaction{
                
                let insert = self.TABLE_ORDERS_OFFLINE.filter(ID == lastId).update(
                    self.ID <- x.id,
                    self.USER <- x.user,
                    self.USERNAME <- x.username,
                    self.SPOT_ID <- x.coffee_spot,
                    self.FULL_PRICE <- x.full_price,
                    self.DATE <- x.date,
                    self.ORDER_TIME <- x.order_time,
                    self.STATUS <- x.status,
                    self.CASH_PAYMENT <- x.cash_payment,
                    self.CARD_PAYMENT <- x.card_payment,
                    self.DISCOUNT <- x.discount,
                    self.IS_POSTED <- x.is_posted.hashValue,
                    self.LIST_POS <- x.list_pos
                )
                
                do{
                    try self.database.run(insert)
                    print("Inserted")
                } catch{
                    print(error)
                    print("Not inserted")
                }
            }
        }
        catch{
            print("Database \(error)")
        }
    }
    
    func getOrdersOffline() -> [OrderOffline]{
        var response = [OrderOffline]()
        do{
            try database.transaction{
                let select = TABLE_ORDERS_OFFLINE.order(LIST_POS.asc).select([
                    ID,
                    USER,
                    USERNAME,
                    SPOT_ID,
                    FULL_PRICE,
                    DATE,
                    ORDER_TIME,
                    STATUS,
                    CASH_PAYMENT,
                    CARD_PAYMENT,
                    DISCOUNT,
                    IS_POSTED,
                    LIST_POS
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(OrderOffline(
                            id: item[self.ID],
                            user : item[self.USER] ,
                            username : item[self.USERNAME] ,
                            coffee_spot : item[self.SPOT_ID] ,
                            full_price : item[self.FULL_PRICE],
                            date : item[self.DATE],
                            order_time : item[self.ORDER_TIME],
                            status : item[self.STATUS],
                            cash_payment : item[self.CASH_PAYMENT],
                            card_payment : item[self.CARD_PAYMENT],
                            discount : item[self.DISCOUNT],
                            is_posted : item[self.IS_POSTED] == 1,
                            list_pos : item[self.LIST_POS]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func getOrdersOfflineNotPosted() -> [OrderOffline]{
        var response = [OrderOffline]()
        do{
            try database.transaction{
                let select = TABLE_ORDERS_OFFLINE.filter(IS_POSTED == 0).order(LIST_POS.asc).select([
                    ID,
                    USER,
                    USERNAME,
                    SPOT_ID,
                    FULL_PRICE,
                    DATE,
                    ORDER_TIME,
                    STATUS,
                    CASH_PAYMENT,
                    CARD_PAYMENT,
                    DISCOUNT,
                    IS_POSTED,
                    LIST_POS
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        
                        response.append(OrderOffline(
                            id: item[self.ID],
                            user : item[self.USER] ,
                            username : item[self.USERNAME] ,
                            coffee_spot : item[self.SPOT_ID] ,
                            full_price : item[self.FULL_PRICE],
                            date : item[self.DATE],
                            order_time : item[self.ORDER_TIME],
                            status : item[self.STATUS],
                            cash_payment : item[self.CASH_PAYMENT],
                            card_payment : item[self.CARD_PAYMENT],
                            discount : item[self.DISCOUNT],
                            is_posted : item[self.IS_POSTED] == 1,
                            list_pos : item[self.LIST_POS]
                        ))
                        
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func getLastOrdersOfflineId() -> Int{
        var response : Int = 0
        do{
            try database.transaction{
                let select = TABLE_ORDERS_OFFLINE.order(LIST_POS.desc).select([
                    ID,
                    LIST_POS
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        response = item[self.ID]
                        break
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func delStorageItems() {
        let del = self.TABLE_STORAGE_ITEMS.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    func setStorageItems(list: [StorageItemElem]){
        delStorageItems()
        createTableStorageItems()
        do{
            try database.transaction{
                for x in list{
                    let insert = self.TABLE_STORAGE_ITEMS.insert(
                        self.ID <- x.id,
                        self.SPOT_ID <- x.spot,
                        self.NAME <- x.name,
                        self.PRODUCT_TYPE <- x.product_type,
                        self.TYPE <- x.type,
                        self.BARISTA_BALANCE <- x.barista_balance
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        } catch{
            print("Database \(error)")
        }
    }
    
    func getStorageItems() -> [StorageItemElem]{
        var response = [StorageItemElem]()
        do{
            try database.transaction{
                let select = TABLE_STORAGE_ITEMS.select([
                    ID,
                    SPOT_ID,
                    NAME,
                    PRODUCT_TYPE,
                    TYPE,
                    BARISTA_BALANCE
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        var elem = [String : Any]()
                        elem["id"] = item[self.ID]
                        elem["spot"] = item[self.SPOT_ID]
                        elem["name"] = item[self.NAME]
                        elem["product_type"] = item[self.PRODUCT_TYPE]
                        elem["type"] = item[self.TYPE]
                        elem["barista_balance"] = item[self.BARISTA_BALANCE]
                        
                        response.append(StorageItemElem(mas: elem))
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
    
    func delStorageTypes() {
        let del = self.TABLE_STORAGE_TYPES.delete()
        do{
            try database.run(del)
        } catch {
            print(error)
        }
    }
    func setStorageTypes(list: [StorageItemType]){
        delStorageTypes()
        createTableStorageTypes()
        do{
            try database.transaction{
                for x in list{
                    let insert = self.TABLE_STORAGE_TYPES.insert(
                        self.ID <- x.id,
                        self.NAME <- x.name
                    )
                    
                    do{
                        try self.database.run(insert)
                        print("Inserted")
                    } catch{
                        print(error)
                        print("Not inserted")
                    }
                }
            }
        } catch{
            print("Database \(error)")
        }
    }
    
    func getStorageTypes() -> [StorageItemType]{
        var response = [StorageItemType]()
        do{
            try database.transaction{
                let select = TABLE_STORAGE_TYPES.select([
                    ID,
                    NAME
                    ])
                
                do{
                    let list = try self.database.prepare(select)
                    for item in list{
                        var elem = [String : Any]()
                        elem["id"] = item[self.ID]
                        elem["name"] = item[self.NAME]
                        
                        response.append(StorageItemType(mas: elem))
                    }
                } catch{
                    print(error)
                }
                
            }
        } catch{
            print("Database \(error)")
        }
        
        return response
    }
}
