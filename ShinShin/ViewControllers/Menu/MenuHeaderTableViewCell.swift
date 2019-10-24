//
//  MenuHeaderTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/27/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewIconUser: UIView!
    @IBOutlet weak var imageIconUser: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSaldo: UIButton!
    @IBOutlet weak var btnRetirar: UIButton!
    @IBOutlet weak var btnTickets: UIButton!
    @IBOutlet weak var btnHistorial: UIButton!
    @IBOutlet weak var lblBonificacion: UILabel!
    @IBOutlet weak var viewFooter: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewUser.layer.cornerRadius = 35.0
        viewIconUser.layer.cornerRadius = viewIconUser.frame.width / 2
        if let imageURL = Model.user?.imgUrl{
            imageIconUser.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            imageIconUser.layer.cornerRadius = imageIconUser.frame.width / 2
            imageIconUser.loadImage(url: URL(string: imageURL)!)
        }
        else{
            imageIconUser.frame = CGRect(x: 14, y: 14, width: 32, height: 32)
            imageIconUser.image = UIImage(named:"user-orange")
        }
        
        btnRetirar.layer.cornerRadius = 20.0
        btnRetirar.tag = 1
        
        btnTickets.layer.cornerRadius = 20.0
        btnTickets.tag = 2
        
        btnHistorial.layer.cornerRadius = 20.0
        btnHistorial.tag = 3
        
        viewFooter.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
