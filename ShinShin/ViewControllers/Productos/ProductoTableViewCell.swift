//
//  ProductoTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/6/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ProductoTableViewCell: UITableViewCell {
    @IBOutlet weak var imageProducto: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblContenido: UILabel!
    @IBOutlet weak var btnMasInfo: UIButton!
    @IBOutlet weak var lblBonificacion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblBonificacion.layer.masksToBounds = true
        lblBonificacion.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
