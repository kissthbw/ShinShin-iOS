//
//  DeptoItemCollectionViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/5/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class DeptoItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblDepto: UILabel!
    
    override func awakeFromNib() {
        view.layer.cornerRadius = 10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
