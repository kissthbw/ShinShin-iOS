//
//  TicketProductoTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 8/26/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class TicketProductoTableViewCell: UITableViewCell {

    //MARK: - Propiedades
    @IBOutlet weak var viewImageContainer: UIView!
    @IBOutlet weak var imageProductoView: UIImageView!
    @IBOutlet weak var lblProducto: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblCodigo: UILabel!
    @IBOutlet weak var lblBonificacion: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewImageContainer.layer.cornerRadius = 10.0
        lblBonificacion.layer.cornerRadius = 10.0
        lblBonificacion.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
