//
//  BancoDetailTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BancoDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtTarjeta: UITextField!{
        didSet { txtTarjeta?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var txtMes: UITextField!{
        didSet { txtTarjeta?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var txtAnio: UITextField!{
        didSet { txtTarjeta?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var btnGuardar: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnGuardar.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
