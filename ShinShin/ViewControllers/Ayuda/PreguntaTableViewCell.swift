//
//  PreguntaTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PreguntaTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPregunta: UILabel!
    @IBOutlet weak var txtRespuesta: UITextView!
    @IBOutlet weak var btnArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
