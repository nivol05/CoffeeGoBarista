//
//  Cell.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 02.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {

//    var gradientLayer : CAGradientLayer
    
    @IBOutlet weak var orderIndex: UILabel!
    @IBOutlet weak var LblTime: UILabel!
    @IBOutlet weak var LblPrice: UILabel!
    @IBOutlet weak var BG3: UIView!
    @IBOutlet weak var BG2: UIView!
    @IBOutlet weak var BG1: UIView!
    @IBOutlet weak var BG4: UIView!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var orderlbl: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBG: UIButton!
    
    var gradientLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        BG.layer.cornerRadius = 5
        buttonBG.layer.cornerRadius = 5
        BG1.layer.cornerRadius = 15
        BG2.layer.cornerRadius = 15
        BG3.layer.cornerRadius = 15
        BG4.layer.cornerRadius = 15
        BG.layer.masksToBounds = false

        
    }
    

}