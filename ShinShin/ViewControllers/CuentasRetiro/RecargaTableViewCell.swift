//
//  RecargaTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class RecargaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblAlias: UILabel!
    @IBOutlet weak var lblNumero: UILabel!
    @IBOutlet weak var lblCompania: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
