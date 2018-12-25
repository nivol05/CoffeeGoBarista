//
//  CashboxList.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 02.07.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class CashboxList: UICollectionViewCell {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var BG: UIView!
    @IBOutlet weak var BG1: UIView!
    @IBOutlet weak var BG2: UIView!
    @IBOutlet weak var BGOrderIndex: UIView!
    @IBOutlet weak var BG3: UIView!
    @IBOutlet weak var BtnStatus: UIButton!
    @IBOutlet weak var orderIndex: UILabel!
    
    @IBOutlet weak var LblTime: UILabel!
    @IBOutlet weak var LblOrderRow: UILabel!
    @IBOutlet weak var LblPrice: UILabel!
    
    override func awakeFromNib() {
        orderIndex.layer.cornerRadius = 41 / 2
        orderIndex.layer.masksToBounds = true
        BGOrderIndex.layer.cornerRadius = 35 / 2
        BG.layer.cornerRadius = 5
        BG1.layer.cornerRadius = 15
        BG2.layer.cornerRadius = 15
        BG3.layer.cornerRadius = 15
        BtnStatus.layer.cornerRadius = 15
    }
}
