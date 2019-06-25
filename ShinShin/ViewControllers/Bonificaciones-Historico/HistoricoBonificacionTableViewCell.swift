//
//  HistoricoBonificacionTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/3/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class HistoricoBonificacionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblEstado: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
