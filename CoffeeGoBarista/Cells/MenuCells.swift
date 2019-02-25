//
//  MenuCells.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 12/25/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class MenuCells: UITableViewCell {

    @IBOutlet weak var activeBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var thingImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRatio(view: activeBtn, ratio: activeBtn.frame.height/2 , masksToBounds: false)
        cornerRatio(view: thingImg, ratio: 5, masksToBounds: false)
    }

}
