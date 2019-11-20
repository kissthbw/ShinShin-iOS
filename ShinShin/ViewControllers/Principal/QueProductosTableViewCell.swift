//
//  QueProductosTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/23/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class QueProductosTableViewCell: UITableViewCell {

    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var txtProductos: UITextField!
    @IBOutlet weak var btnEnviar: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewText.layer.cornerRadius = 10.0
        btnEnviar.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func isValid() -> (valid: Bool, alert: UIAlertController?){
        if Validations.isEmpty(value: txtProductos.text!){
            txtProductos.showError(true, superView: true)
            let alert = Validations.show(message: "Debes llenar el campo de sugerencia", with: "ShingShing")
            
            return (false, alert)
        }
        
        if txtProductos.text!.count < 2{
            txtProductos.showError(true, superView: true)
            let alert = Validations.show(message: "La longitud minima es de 2 posiciones", with: "ShingShing")
            
            return (false, alert)
        }
        
        return (true, nil)
    }
}
