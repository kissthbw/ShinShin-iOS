//
//  MenuOpcionesTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/27/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class MenuOpcionesTableViewCell: UITableViewCell {

    @IBOutlet weak var viewOption: UIView!
    @IBOutlet weak var imageOption: UIImageView!
    @IBOutlet weak var lblOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewOption.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
