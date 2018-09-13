//
//  OrdersList.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 30.06.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class OrdersList: UICollectionViewCell {
    
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var OrderLbl: UILabel!
    
    func ConerRatio(){
        
        BG.layer.cornerRadius = 5
        BG.layer.masksToBounds = false
        BG.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        BG.layer.shadowOffset = CGSize(width: 0, height: 0)
        BG.layer.shadowOpacity = 0.8
        
    }
}
