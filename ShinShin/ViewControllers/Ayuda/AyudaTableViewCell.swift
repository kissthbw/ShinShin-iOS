//
//  AyudaTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/20/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class AyudaTableViewCell: UITableViewCell {

    @IBOutlet weak var viewTour: UIView!
    @IBOutlet weak var viewComo: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewTour.layer.cornerRadius = 10.0
        viewComo.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
