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
    @IBOutlet weak var BG3: UIView!
    @IBOutlet weak var BtnStatus: UIButton!
    
    @IBOutlet weak var LblTime: UILabel!
    @IBOutlet weak var LblOrderRow: UILabel!
    @IBOutlet weak var LblPrice: UILabel!
    func ConerRatio(){
        
//        self.contentView.translatesAutoresizingMaskIntoConstraints = false
//        let screenWidth = UIScreen.main.bounds.size.width
//        //        var screenSize = screenWidth
//        widthConstraint.constant = screenWidth - (2 * 12)
//        print(screenWidth)
//        if screenWidth >= 750 {
//            widthConstraint.constant = screenWidth / 3.3
//            //            widthConstraint.constant = screenWidth - 30
//        }
//        if screenWidth <= 750 && screenWidth > 667{
//            widthConstraint.constant = screenWidth / 3.3
//        }
//        if screenWidth == 667{
//            widthConstraint.constant = screenWidth / 2.2
//        }
//        if screenWidth == 568{
//            widthConstraint.constant = screenWidth / 2.2
//        }
        
        BG.layer.cornerRadius = 5
        BG1.layer.cornerRadius = 15
        BG2.layer.cornerRadius = 15
        BG3.layer.cornerRadius = 15
        BtnStatus.layer.cornerRadius = 15
//        BG.layer.masksToBounds = false
//        BG.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
//        BG.layer.shadowOffset = CGSize(width: 0, height: 0)
//        BG.layer.shadowOpacity = 0.8
        
    }
}
