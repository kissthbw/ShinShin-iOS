//
//  PrincipalBonificacionTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/3/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PrincipalBonificacionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBonificacion: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomView.layer.cornerRadius = 10.0
        lblBonificacion.text = Validations.formatWith(Model.totalBonificacion)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
