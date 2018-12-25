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
    
    var user : ElementUser!
    let database = DBBarista()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views()
        if database.getUser() != nil{
            let user = database.getUser()!
            passwordTF.text = user.password
            loginTF.text = user.username
            
            getToken()
        } else {
            passwordTF.text = "barista_coffee_go"
            loginTF.text = "baristago@gmail.com"
        }
    }
    
    func views(){
        cornerRatio(view: signInBtn, ratio: signInBtn.frame.height / 2, masksToBounds : false)
        cornerRatio(view: logoImg, ratio: 10, masksToBounds: false)
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
        checkBarista(username: loginTF.text!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                let coffeeSpots = value as! [[String : Any]]
                
                if coffeeSpots.count == 0{
                    print("zaloopa")
                } else {
                    let spot = ElementCoffeeSpot(mas: coffeeSpots[0])
                    if spot.is_closed{
                        // MAKE TOAST SPOT IS TAKEN
                    } else {
                        current_coffee_spot = spot
                        self.getMenu()
                    }
                }
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getMenu(){
        getProductsForSpot().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                menu = setElementProductList(list: value as! [[String : Any]])
                self.getUser()
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getUser(){
        getUsers(username: loginTF.text!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.user = ElementUser(mas: (value as! [[String : Any]])[0])
                self.user.password = self.passwordTF.text!
                self.postFCM(id: self.user.id)
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func postFCM(id : Int){
        
        let params: [String: Any] = [
            "name": loginTF.text!,
            "user": id,
            "active" : true,
            "device_id" : "",
            "registration_id" : Messaging.messaging().fcmToken!,
            "type" : "ios"
        ]
        
        postFcmDevice(toPost: params).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                if self.database.getUser() == nil{
                    self.database.setUser(user: self.user)
                }
                self.performSegue(withIdentifier: "main", sender: self.signInBtn)
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getToken(){

        let params: [String: Any] = [
            "username": loginTF.text!,
            "password": passwordTF.text!
        ]
        getTokenAuth(user: params).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                let jsonData = JSON(value)
                if jsonData["token"] == JSON.null{
                    print("zalupa")
                } else {
                    let token = "Token \(jsonData["token"].string!)"
                    header = [
                        "Authorization": token
                    ]
                    self.check()
                }
                break
            case .failure(let error):
                //                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                //                self.stopAnimating()
                print(error)
                break
            }
        }
    }
}
