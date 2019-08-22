//
//  TicketNotFoundTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 8/21/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class TicketNotFoundTableViewCell: UITableViewCell {

    @IBOutlet weak var btnTicket: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnTicket.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
