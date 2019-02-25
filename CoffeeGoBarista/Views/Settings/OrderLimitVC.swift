//
//  OrderLimitVC.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/20/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class OrderLimitVC: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var limitLbl: UILabel!
    @IBOutlet weak var limitTF: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    
    let limitStart = "На данный момент лимит заказа составляет: "
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        views()
        
        self.limitLbl.text = "\(limitStart) \(current_coffee_spot.max_order_limit!) грн"
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }

    func views(){
        cornerRatio(view: confirmBtn, ratio: 5, masksToBounds: false)
        cornerRatio(view: cancelBtn, ratio: 5, masksToBounds: false)
        cornerRatio(view: BG, ratio: 10, masksToBounds: false)
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        if self.limitTF.text! == ""{
            self.dismiss(animated: true, completion: nil)
        } else {
            patchLimit(limit: "\(Int(self.limitTF.text!)!)")
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func patchLimit(limit: String){
        startAnimating(type : NVActivityIndicatorType.ballPulseSync)
        patchSpotLimit(limit: limit, isClosed: nil).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                print(value)
                current_coffee_spot.max_order_limit = limit
                self.view.makeToast("Лимит успешно изменен")
                self.stopAnimating()
                self.dismiss(animated: true, completion: nil)
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
