//
//  BancoBonificacionTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/25/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BancoBonificacionTableViewCell: UITableViewCell {

    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var txtCantidad: UITextField!
    @IBOutlet weak var txtCuenta: UITextField!
    @IBOutlet weak var btnSolicitar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSolicitar.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
