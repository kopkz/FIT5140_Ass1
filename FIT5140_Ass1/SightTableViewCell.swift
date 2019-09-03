//
//  SightTableViewCell.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 2/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit

class SightTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var shortDesLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
