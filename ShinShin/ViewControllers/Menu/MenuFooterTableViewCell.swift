//
//  MenuFooterTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/27/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class MenuFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var btnCerrarSesion: UIButton!
    @IBOutlet weak var btnPrivacidad: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
