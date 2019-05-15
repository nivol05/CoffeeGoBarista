//
//  CakeVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/25/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseMessaging
import Toast_Swift
import NVActivityIndicatorView
import XLPagerTabStrip

class CakeVC: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: #imageLiteral(resourceName: "Deserts"))
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var products : [ElementProduct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = getProductsForType(type: 2)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCells
        
        cell.activeBtn.tag = indexPath.row
        self.setStatusView(btn: cell.activeBtn, active: data.active)
        cell.activeBtn.addTarget(self, action: #selector(activeBtn(sender:)), for: .touchUpInside)
        
        cell.nameLbl.text = data.name
        
        if data.img != nil{
            cell.thingImg.kf.setImage(with: URL(string: data.img!)!)
        } else{
            cell.thingImg.image = #imageLiteral(resourceName: "coffee-cup")
        }
        
        var price_text = ""
        var onlyPrice : Bool = true
        //
        //            // Checking for small cup
        let l_cup = data.l_cup!
        if l_cup != 0 {
            
            price_text += "\(l_cup) грн"
            
            onlyPrice = false
        }
        //
        //            // Checking for medium cip
        let m_cup = data.m_cup!
        if m_cup != 0 {
            price_text += " / \(m_cup) грн"
            onlyPrice = false
        }
        //
        //            // Checking for big cup
        let b_cup = data.b_cup!
        if b_cup != 0 {
            price_text += " / \(b_cup) грн"
            onlyPrice = false
        }
        //
        //            // Set the only price
        let price = data.price!
        
        if onlyPrice{
            price_text += "\(price) грн"
        }
        cell.priceLbl.text = price_text
        
        return cell
    }
    
    func setStatusView(btn: UIButton, active: Bool){
        
        if active{
            btn.setTitle("Активно", for: UIControl.State())
            btn.layer.backgroundColor = UIColor(red: 50/255, green: 215/255, blue: 75/255, alpha: 1).cgColor
        } else {
            btn.setTitle("Не активно", for: UIControl.State())
            btn.layer.backgroundColor = UIColor(red: 229/255, green: 57/255, blue: 53/255, alpha: 1).cgColor
        }
        
    }

    @objc func activeBtn(sender:UIButton){
        
        let data = products[sender.tag]
        print("KNOPKa")
        data.active.toggle()
        self.setStatusView(btn: sender , active: data.active)
        
        patchProduct(productId: data.id, active: data.active).responseJSON{ (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                db.updateProduct(x: data, id: data.id)
                print("succes")
                break
            case .failure(let error):
                self.view.makeToast("Произошла ошибка загрузки, попробуйте еще раз")
                data.active.toggle()
                self.setStatusView(btn: sender , active: data.active)
                self.stopAnimating()
                print(error)
                break
            }
            
        }
    }

}
