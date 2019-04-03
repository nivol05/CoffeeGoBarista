//
//  ItemCell.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/13/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var coffeeNameLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var countCoffeeLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
