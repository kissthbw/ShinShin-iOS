//
//  NotificacionesTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/16/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class NotificacionesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewNotificacion: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
