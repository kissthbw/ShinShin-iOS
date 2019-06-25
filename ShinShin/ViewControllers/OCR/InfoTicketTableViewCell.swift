//
//  InfoTicketTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/12/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class InfoTicketTableViewCell: UITableViewCell {
    @IBOutlet weak var viewTienda: UIView!
    @IBOutlet weak var viewTicket: UIView!
    @IBOutlet weak var imgTienda: UIImageView!
    @IBOutlet weak var lblTicket: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
