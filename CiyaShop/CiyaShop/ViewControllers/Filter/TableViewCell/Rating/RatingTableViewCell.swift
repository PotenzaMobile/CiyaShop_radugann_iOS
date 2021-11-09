//
//  RatingTableViewCell.swift
//  CiyaShop
//
//  Created by Kaushal Parmar on 12/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Cosmos
class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var vwRating: CosmosView!
    @IBOutlet weak var btnSelect: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*
        
        btnSelect.setImage(UIImage(named: "checkbox_unselected")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnSelect.setImage(UIImage(named: "checkbox_selected")?.withRenderingMode(.alwaysTemplate), for: .selected)*/
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
