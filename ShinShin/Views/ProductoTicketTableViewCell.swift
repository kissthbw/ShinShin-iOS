//
//  ProductoTicketTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ProductoTicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var lblProducto: UILabel!
    @IBOutlet weak var lblContenido: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblCodigoBarras: UILabel!
    @IBOutlet weak var lblBonificacion: UILabel!
    @IBOutlet weak var viewBonificacion: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBonificacion.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
