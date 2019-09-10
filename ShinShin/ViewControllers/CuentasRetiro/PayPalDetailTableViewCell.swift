//
//  PayPalDetailTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PayPalDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtNombre.layer.cornerRadius = 10.0
        txtId.layer.cornerRadius = 10.0
        txtEmail.layer.cornerRadius = 10.0
        btnGuardar.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
