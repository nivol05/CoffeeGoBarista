//
//  Database.swift
//  CofeeGo
//
//  Created by NI Vol on 9/27/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import SQLite

class DBBarista{
    
    var database : Connection!
    
    let USER_TABLE = Table("user")
    
    let USER_ID = Expression<Int>("id")
    let USER_FIRST_NAME = Expression<String>("first_name")
    let USER_PASSWORD = Expression<String>("password")
    let USER_USERNAME = Expression<String>("username")
    
    init() {
        do{
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("coffeeGo").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        createTableUser()
    }
    
    func createTableUser(){
        let createTable = self.USER_TABLE.create{ (table) in
            table.column(self.USER_ID, primaryKey: true)
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
    
    func setUser(user: ElementUser){
        let insertUser = self.USER_TABLE.insert(
            self.USER_ID <- user.id,
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
            USER_ID,
            USER_FIRST_NAME,
            USER_USERNAME,
            USER_PASSWORD
            ])
        do{
            let users = try self.database.prepare(select)
            for user in users{
                var elem = [String : Any]()
                elem["id"] = user[self.USER_ID]
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
}


