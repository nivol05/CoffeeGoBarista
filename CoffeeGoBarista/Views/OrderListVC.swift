//
//  OrderListVC.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 01.09.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class OrderListVC: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var orders : [String: Any] = [String: Any]()
    var ordersItem : [[String: Any]] = [[String: Any]]()
    
    var Id : Int!
    
    @IBOutlet weak var TFDate: UITextField!
    @IBOutlet weak var TFTime: UITextField!
    @IBOutlet weak var TFPrice: UITextField!
    @IBOutlet weak var CommentBG: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Comment: UITextView!
    @IBOutlet weak var BtnStatus: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommentBG.layer.cornerRadius = 10
        CommentBG.layer.masksToBounds = false

        print(Id!)
        
        BtnStatus.layer.cornerRadius = 20
        
        textField(TF: TFDate)
        textField(TF: TFTime)
        textField(TF: TFPrice)
        
        getOrdersItem()
        getOrders()
    
    }
    
    func textField(TF : UITextField){
        
        TF.layer.cornerRadius = 15
        TF.layer.masksToBounds = true
        TF.layer.borderColor = UIColor(white: 0.88, alpha: 1).cgColor
        TF.layer.borderWidth = 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ordersItem.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderList", for: indexPath) as? OrderCell
        let ordersElements = ordersItem[indexPath.row]
        var avatar_url: URL
        let product_id = ordersElements["product"] as! Int
        var element : [String : Any] = [String: Any]()
        for i in staticData.menu{
            if product_id == i["id"] as! Int{
                element = i
                break
            }
        }
        
        avatar_url = URL(string: element["img"] as! String)!
        cell?.ImgCoffee.kf.setImage(with: avatar_url)

        cell?.LblName.text = element["name"] as? String

        
        var coffee_price = ""
        switch "\(ordersElements["cup_size"]!)"{

        case "l":
            coffee_price += "\(element["l_cup"]!)"
            break
        case "m":
            coffee_price +=  "\(element["m_cup"]!)"
            break
        case "b":
            coffee_price += "\(element["b_cup"]!)"
            break
        default:
            coffee_price += "\(element["price"]!)"
        }
        coffee_price += " grn"
        cell?.LblPrice.text = coffee_price
//            " " + context.getString(R.string.grn)
        
        let sugar = ordersElements["sugar"] as? Double
        let syrup = "\(ordersElements["syrups"]!)"
        let species = "\(ordersElements["species"]!)"
        let additions = ("\(ordersElements["additionals"]!)")
        
        
//        cell?.LbllAdditions.text = ("\(ordersElements["additionals"]!)")
        
        if additions != "" && additions != "<null>" {
            cell?.LbllAdditions.text = "Додатки: \(additions)"
        } else {
            cell?.LbllAdditions.text = ""
        }
    
        if species != ""{
            cell?.LblSpice.text = "Специи: \(species)"
        } else {
            cell?.LblSpice.text = ""
        }
        if sugar != 0.0 {
            cell?.LblSugar.text = "Сахар: \(sugar!)"
        } else {
            cell?.LblSpice.text = ""
        }
//        cell?.LblSugar.text = "Сахар: \(sugar!)"

        if syrup != ""{
            cell?.LblSyrup.text = "Сиропи: \(syrup)"
        } else {
            cell?.LblSyrup.text = ""
        }
        
        cell?.LblUltPrice.text = "Всего: \(ordersElements["item_price"]!)грн"
        
        return cell!
        
    }
    
    func getOrders(){
        let isUser = "\(BASE_URL)\(Orders)\(Id!)"
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            self.orders = response.result.value as! [String : Any]
            self.Comment.text = self.orders["comment"] as? String
            self.TFPrice.text = "\(self.orders["full_price"]!) грн"
            self.TFDate.text = self.orders["date"] as? String
            self.TFTime.text = self.orders["order_time"] as? String
        }
    }
    
    func getOrdersItem(){
        let isUser = "\(BASE_URL)\(Order_Items)\(Id!)"
        let params : HTTPHeaders = [
            "Authorization": staticData.token
        ]
        
        Alamofire.request(isUser, method: .get , parameters: nil, encoding: URLEncoding(), headers : params).responseJSON { (response) in
            
            self.ordersItem = response.result.value as! [[String : Any]]
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            print(staticData.menu)
            print(self.ordersItem)
            
        }
    }
    
}
