//
//  StartVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 1/12/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class StartVC: UIViewController, NVActivityIndicatorViewable {

    let user = DBBarista().getUser()
    
    @IBOutlet weak var refreshBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        checkUser()
    }
    
    func checkUser(){
        if user != nil{
            if (getUserToken().isEmpty){
                getToken(username: user!.username, password: user!.password)
            } else {
                header = [
                    "Authorization": getUserToken()
                ]
                setTabs()
            }
        } else{
            self.stopAnimating()
            self.performSegue(withIdentifier: "logibView", sender: self)
        }
    }
    
    func getToken(username: String, password: String){
        
        let params: [String: Any] = [
            "username": username,
            "password": password
        ]
        getTokenAuth(user: params).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                let jsonData = JSON(value)
                if jsonData["token"] == JSON.null{
                    print("zalupa")
                    self.stopAnimating()
                    self.performSegue(withIdentifier: "logibView", sender: self)
                } else {
                    setUserToken(login: jsonData["token"].string!)
                    header = [
                        "Authorization": getUserToken()
                    ]
                    self.check()
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.refreshBtn.isHidden = false
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    func check(){
        checkBarista(username: user!.username).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                let coffeeSpots = value as! [[String : Any]]
                
                if coffeeSpots.count == 0{
                    self.stopAnimating()
                 self.performSegue(withIdentifier: "logibView", sender: self)
                    
                    print("zaloopa")
                } else {
                    let spot = ElementCoffeeSpot(mas: coffeeSpots[0])
                    // MAKE !ISCLOSED
                    if spot.is_closed{
                        self.view.makeToast("Аккаунт уже используется")
                        self.stopAnimating()
                        self.performSegue(withIdentifier: "logibView", sender: self)
                        self.refreshBtn.isHidden = false
                    } else {
                        setSpotId(id: spot.id)
                        setMaxOrderLimit(value: spot.max_order_limit)
                        setOnlineEnabled(value: spot.coffee_go)
                        setCashBoxEnabled(value: spot.cashbox)
                        self.downloadData()
                    }
                }
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                self.refreshBtn.isHidden = false
                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func downloadData(){
        
        let error = {
            self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
            self.refreshBtn.isHidden = false
            self.stopAnimating()
        }
        
        let success = {
            self.setTabs()
        }
        
        LoadUtils(error: error, success: success).startDownloading()
    }
    
    func setTabs(){
        tabs = []
        
        let menu = db.getProducts()
        
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
        
        setNotifsEnabled(enabled: true)
        self.performSegue(withIdentifier: "Main", sender: self)
        
    }

    @IBAction func refreshBtn(_ sender: Any) {
        self.refreshBtn.isHidden = true
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        checkUser()
    }
}
