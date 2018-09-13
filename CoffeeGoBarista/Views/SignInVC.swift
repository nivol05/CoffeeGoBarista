//
//  SignInVC.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 30.08.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseMessaging

class SignInVC: UIViewController {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var loginTF: UITextField!
    
    var coffeeSpots : [[String: Any]] = [[String: Any]]()
    var user : [[String: Any]] = [[String: Any]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.text = "barista_coffee_go"
        loginTF.text = "baristago@gmail.com"
    }
    @IBAction func signInBtn(_ sender: Any) {
        if notEmpty(){
            
            getToken()
        }
    }
    
    func notEmpty() -> Bool {
        if (passwordTF.text?.count)! > 0 && (loginTF.text?.count)! > 0 {
            return true
        }
        print("Ne zapolnil")
        return false
    }
    
    
    func check(){
        let IsBarista = "\(BASE_URL)\(checkBarista)\(loginTF.text!)"
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(IsBarista, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            if response.result.isSuccess {
                self.coffeeSpots = response.result.value as! [[String : Any]]
                print(self.coffeeSpots)
                
                if self.coffeeSpots.count == 0{
                    print("zalupa")
                } else {
                    
                    staticData.spotId = self.coffeeSpots[0]["id"] as! Int
                    self.getMenu()
                    
                    self.getUser()
                }
                
                
            } else {
//                print("Hui")
            }
        }
    }
    
    func getMenu(){
        let MenuUrl = "\(BASE_URL)\(Menu)\(staticData.spotId)"
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        Alamofire.request(MenuUrl, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            if response.result.isSuccess {
                staticData.menu = response.result.value as! [[String : Any]]
            }
            
        }
    }
    
    func getUser(){
        let isUser = "\(BASE_URL)\(checkBarista)\(loginTF.text!)"
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            if response.result.isSuccess {
                self.user = response.result.value as! [[String : Any]]
                self.performSegue(withIdentifier: "main", sender: self.signInBtn)
//                self.postFCM(id: self.user[0]["id"] as! Int)
                
    
            } else {
                print("Hui")
            }
        }
    }
    
    func postFCM(id : Int){
        
        let url = "\(BASE_URL)\(FCM)"
        let params: [String: Any] = [
            "name": loginTF.text!,
            "user": id,
            "active" : true,
            "device_id" : "",
            "registration_id" : Messaging.messaging().fcmToken!,
            "type" : "ios"
        ]
        
        let paramsAuth : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        
        Alamofire.request(url, method: .post , parameters: params, encoding: URLEncoding(), headers: paramsAuth).responseJSON { (response) in
            
            if response.result.isSuccess {
                print(response.result.value)
                
                
            } else {
                print("Hui")
            }
        }
    }
    
    func getToken(){

        let url = "\(BASE_URL)\(pathLog)"
        let params: [String: Any] = [
            "username": loginTF.text!,
            "password": passwordTF.text!
        ]
        
        
        Alamofire.request(url, method: .post , parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
            
            if response.result.isSuccess {
                let jsonData = JSON(response.value!)
                print(response.value!)
                if jsonData["token"] == JSON.null{
                    print("zalupa")
                } else {
                    staticData.token = "Token \(jsonData["token"].string!)"
                    self.check()
                }
               

            } else {
                print("Hui")
            }
        }
    }
}
