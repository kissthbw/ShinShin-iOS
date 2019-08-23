//
//  BonificacionTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/3/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BonificacionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
