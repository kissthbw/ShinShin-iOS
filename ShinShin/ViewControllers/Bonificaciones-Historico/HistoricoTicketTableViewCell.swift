//
//  HistoricoTicketTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/26/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class HistoricoTicketTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTienda: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
