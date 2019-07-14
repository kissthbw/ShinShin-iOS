//
//  FotoTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/29/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class FotoTableViewCell: UITableViewCell {
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var btnFoto: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.layer.cornerRadius = 10.0
        btnFoto.layer.cornerRadius = 10.0
        bottomView.backgroundColor = .white
        lblMensaje.sizeToFit()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
