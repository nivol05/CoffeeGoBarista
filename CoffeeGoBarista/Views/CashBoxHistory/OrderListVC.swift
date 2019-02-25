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
import NVActivityIndicatorView

class OrderListVC: UIViewController, UITableViewDataSource,UITableViewDelegate, NVActivityIndicatorViewable {

    var order : ElementOrder!
    var orderItems : [ElementOrderItem]!
    
    var Id : Int!
    
    @IBOutlet weak var TFDate: UITextField!
    @IBOutlet weak var TFTime: UITextField!
    @IBOutlet weak var TFPrice: UITextField!
    @IBOutlet weak var CommentBG: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Comment: UITextView!
//    @IBOutlet weak var BtnStatus: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        CommentBG.layer.cornerRadius = 10
        CommentBG.layer.masksToBounds = false

        print(Id!)
        
//        BtnStatus.layer.cornerRadius = 20
        
        textField(TF: TFDate)
        textField(TF: TFTime)
        textField(TF: TFPrice)
        
        self.getOrder()
    
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    func textField(TF : UITextField){
        
        TF.layer.cornerRadius = 15
        TF.layer.masksToBounds = true
        TF.layer.borderColor = UIColor(white: 0.88, alpha: 1).cgColor
        TF.layer.borderWidth = 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orderItems == nil{
            return 0
        }
        return orderItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderList", for: indexPath) as? OrderCell
        let orderItem = orderItems[indexPath.row]
        let product_id = orderItem.product
        var element : ElementProduct!
        for i in menu{
            if product_id == i.id{
                element = i
                break
            }
        }
        
        //CoffeeImag
        if element.img != nil{
            cell?.ImgCoffee.kf.setImage(with: URL(string: element.img)!)
        } else{
            cell?.ImgCoffee.image = #imageLiteral(resourceName: "coffee-cup")
        }

        cell?.LblName.text = element.name

        
        var coffee_price = ""
        switch "\(orderItem.cup_size!)"{

        case "l":
            coffee_price += "\(element.l_cup!)"
            break
        case "m":
            coffee_price +=  "\(element.m_cup!)"
            break
        case "b":
            coffee_price += "\(element.b_cup!)"
            break
        default:
            coffee_price += "\(element.price!)"
        }
        coffee_price += " грн"
        cell?.LblPrice.text = coffee_price
//            " " + context.getString(R.string.grn)
        
        let sugar = orderItem.sugar
        let species = "\(orderItem.species!)"
        
        
//        cell?.LbllAdditions.text = ("\(ordersElements["additionals"]!)")
        
        if orderItem.syrups != nil && orderItem.syrups != ""{ // Making syrups string
            let syrupsInStr = orderItem.syrups.components(separatedBy: ", ")
            var syrupsText = "Сиропы: "
            for i in 0..<syrupsInStr.count{
                let value = syrupsInStr[i]
                
                for x in syrups{
                    if value == x["name"] as! String{
                        syrupsText.append(x["name"] as! String)
                        syrupsText.append("( +\(x["price"] as! Int) грн)")
                        break
                    }
                }
                
                
                if i != syrupsInStr.count - 1{
                    syrupsText.append(", ")
                }
            }
            cell?.LblSyrup.text = syrupsText
        } else {
            cell?.LblSyrup.text = ""
        }
        
        if orderItem.additionals != nil && orderItem.additionals != ""{ // Making adds string
            let addsInStr = orderItem.additionals.components(separatedBy: ", ")
            var addsText = "Добавки: "
            for i in 0..<addsInStr.count{
                let value = addsInStr[i]
                
                for x in additionals{
                    if value == x["name"] as! String{
                        addsText.append(x["name"] as! String)
                        addsText.append("( +\(x["price"] as! Int) грн)")
                        break
                    }
                }
                
                
                if i != addsInStr.count - 1{
                    addsText.append(", ")
                }
            }
            cell?.LbllAdditions.text = addsText
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
            cell?.LblSugar.text = ""
        }
//        cell?.LblSugar.text = "Сахар: \(sugar!)"
        
        cell?.LblUltPrice.text = "Всего: \((orderItem.item_price + orderItem.additionals_price)) грн"
        
        return cell!
        
    }
    
    func getOrder(){
        
        getOrderById(orderId: Id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.order = ElementOrder(mas: value as! [String : Any])
                if self.order.comment == ""{
                    self.Comment.text = "Нету комментария"
                } else {
                    self.Comment.text = self.order.comment
                }
                self.TFPrice.text = "\(self.order.full_price!) грн"
                self.TFDate.text = self.order.date
                self.TFTime.text = self.order.order_time
                self.getOrdersItem()
                break
            case .failure(let error):
                                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                                self.stopAnimating()
                print(error)
                break
            }
        }
    }
    
    func getOrdersItem(){
        
        getOrderItemsToOrder(orderId: Id).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                self.orderItems = setElementOrderItemList(list: value as! [[String : Any]])
                self.stopAnimating()
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
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
