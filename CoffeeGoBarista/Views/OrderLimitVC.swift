//
//  OrderLimitVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/20/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class OrderLimitVC: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var limitLbl: UILabel!
    @IBOutlet weak var limitTF: UITextField!
    
    let limitStart = "На данный момент лимит заказа составляет: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views()
        
        self.limitLbl.text = "\(limitStart) \(current_coffee_spot.max_order_limit!) грн"
    }

    func views(){
        cornerRatio(view: confirmBtn, ratio: confirmBtn.frame.height/2, masksToBounds: false)
        cornerRatio(view: BG, ratio: 10, masksToBounds: false)
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        if self.limitTF.text! == ""{
            self.dismiss(animated: true, completion: nil)
        } else {
            patchLimit(limit: self.limitTF.text!)
        }
    }
    
    func patchLimit(limit: String){
//        self.startAnipating()
        patchSpotLimit(limit: limit).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
                current_coffee_spot.max_order_limit = limit
                //                self.view.makeToast("Лимит успешно изменен")
                //                self.stopAnimating()
                self.dismiss(animated: true, completion: nil)
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
