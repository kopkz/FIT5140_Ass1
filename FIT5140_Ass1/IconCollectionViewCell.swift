//
//  IconCollectionViewCell.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 2/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconNameLabel: UILabel!
    
    override var isSelected: Bool{
        didSet(newValue){
            contentView.backgroundColor = newValue ? UIColor.gray : UIColor.white
        }
    }
}
