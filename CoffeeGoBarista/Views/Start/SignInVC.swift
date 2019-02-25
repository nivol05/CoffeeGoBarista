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
import Toast_Swift
import NVActivityIndicatorView

class SignInVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var loginTF: UITextField!
    
    var user : ElementUser!
    
    let database = DBBarista()
    
    var productTypes : [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views()
        loginTF.text = getLogin()
    }
    
    
    
    func views(){
        cornerRatio(view: signInBtn, ratio: signInBtn.frame.height / 2, masksToBounds : false)
        cornerRatio(view: logoImg, ratio: 10, masksToBounds: false)
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        if notEmpty(){
            getToken()
        }
    }
    
    func notEmpty() -> Bool {
        if (passwordTF.text?.count)! > 0 && (loginTF.text?.count)! > 0 {
            return true
        } else{
            stopAnimating()
            self.view.makeToast("Не все поля заполнены")
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
                    self.view.makeToast("Данные введены неверно")
                    self.stopAnimating()
                } else {
                    let spot = ElementCoffeeSpot(mas: coffeeSpots[0])
                    if !spot.is_closed{
                        self.view.makeToast("Аккаунт уже используется")
                        self.stopAnimating()
                    } else {
                        current_coffee_spot = spot
                        self.getMenu()
                    }
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
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
                self.getAdds()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getAdds(){
        getAdditionalsForSpot(spotId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                additionals = value as! [[String : Any]]
                self.getSyrups()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getSyrups(){
        getSyrupsForSpot(spotId: "\(current_coffee_spot.id!)").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                syrups = value as! [[String : Any]]
                self.setTabs()
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func setTabs(){
        tabs = []
        
        for i in 0..<menu.count{
            var here = false
            let potom = menu[i].product_type
            for j in 0..<tabs.count{
                if potom == tabs[j]{
                    here = true
                    
                    break
                }
            }
            if !here{
                tabs.append(potom!)
            }
        }
        tabs.sort()
        print(tabs.count)
        self.getUser()
        
    }
    
    func getUser(){
        getUsers(username: loginTF.text!).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.user = ElementUser(mas: (value as! [[String : Any]])[0])
                self.user.password = self.passwordTF.text!
                self.postFCM(id: self.user.id)
                print("blet \(self.user.username!)")
                
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
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
                self.makeSpotOpened()
                
//                self.performSegue(withIdentifier: "main", sender: self.signInBtn)
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func makeSpotOpened(){
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        patchSpotLimit(limit: nil, isClosed: false).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
                self.stopAnimating()
                
                setLogin(login: self.loginTF.text!)
                setNotifsEnabled(enabled: true)
                self.performSegue(withIdentifier: "main", sender: self)
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
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
                    self.view.makeToast("Данные введены неверно")
                    self.stopAnimating()
                } else {
                    let token = "Token \(jsonData["token"].string!)"
                    header = [
                        "Authorization": token
                    ]
                    self.check()
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
}
