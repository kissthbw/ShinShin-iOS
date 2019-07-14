//
//  TotalTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/12/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class TotalTicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnEnviar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnEnviar.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
