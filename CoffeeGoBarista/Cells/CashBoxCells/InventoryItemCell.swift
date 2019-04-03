//
//  InventoryItemCell.swift
//  CoffeeGoBarista
//
//  Created by NI Vol on 3/26/19.
//  Copyright © 2019 Ni VoL. All rights reserved.
//

import UIKit

class InventoryItemCell: UITableViewCell {

    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    @IBInspectable var selectionColor: UIColor = .gray {
        didSet {
            configureSelectedBackgroundView()
        }
    }
    
    func configureSelectedBackgroundView() {
        let view = UIView()
        view.backgroundColor = selectionColor
        selectedBackgroundView = view
    }

}
