//
//  OrderItems.swift
//  CoffeeGoBarista
//
//  Created by Ni VoL on 04.09.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import UIKit

class OrderItems: UITableViewCell {

    @IBOutlet weak var ImgCoffee: UIImageView!
    
    @IBOutlet weak var LbllAdditions: UILabel!
    @IBOutlet weak var LblName: UILabel!
    @IBOutlet weak var LblPrice: UILabel!
    @IBOutlet weak var LblSugar: UILabel!
    @IBOutlet weak var LblSyrup: UILabel!
    @IBOutlet weak var LblSpice: UILabel!
    @IBOutlet weak var LblUltPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ImgCoffee.layer.cornerRadius = 5
        ImgCoffee.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
