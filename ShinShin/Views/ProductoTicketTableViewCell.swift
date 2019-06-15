//
//  ProductoTicketTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ProductoTicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewProducto: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPresentacion: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblCodigo: UILabel!
    @IBOutlet weak var lblBonificacion: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblBonificacion.layer.masksToBounds = true
        lblBonificacion.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
