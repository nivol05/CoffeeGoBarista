//
//  OfflineOrderListCell.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/14/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class OfflineOrderListCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var fullPriceLbl: UILabel!
    @IBOutlet weak var cupLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
