//
//  TimeVC.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 30.06.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class TimeVC: UIViewController {

    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var BG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conerRatio(view: BG , float : 12)
        conerRatio(view: saveBtn , float : 4)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.hidesBottomBarWhenPushed = true
    }
    
    @IBAction func SavedBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func conerRatio(view : UIView, float : Float){
        view.layer.cornerRadius = CGFloat(float)
    }
}
