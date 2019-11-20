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
    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var viewRespuesta: UIView!
//    @IBOutlet weak var txtRespuesta: UITextView!
    var txtRespuesta: UITextView
    
    required init?(coder: NSCoder) {
        let rect = CGRect(x: 8, y: 8, width: 359, height: 214)
        txtRespuesta = UITextView(frame: rect)
        txtRespuesta.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        txtRespuesta.font = UIFont(name: "Nunito Light", size: 15)
        txtRespuesta.backgroundColor = .clear
        
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewRespuesta.addSubview(txtRespuesta)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
