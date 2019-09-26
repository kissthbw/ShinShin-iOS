//
//  PrincipalBonificacionTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/3/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PrincipalBonificacionTableViewCell: UITableViewCell {

    //MARK: - Propiedades
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lblBonificacion: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var imgRetirar: UIImageView!
    @IBOutlet weak var imgTickets: UIImageView!
    @IBOutlet weak var imgHistorial: UIImageView!
    @IBOutlet weak var btnRetirar: UIButton!
    @IBOutlet weak var btnTickets: UIButton!
    @IBOutlet weak var btnHistorial: UIButton!
    @IBOutlet weak var indicatorView: UIImageView!
    
    enum ProcesoTag: Int {
        case Retirar = 1, Tickets, Historico
    }
    
    let unselectedColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6)
    var btnSelected = ProcesoTag.Retirar.rawValue
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnRetirar.tag = ProcesoTag.Retirar.rawValue
        btnTickets.tag = ProcesoTag.Tickets.rawValue
        btnHistorial.tag = ProcesoTag.Historico.rawValue
        
        let alpha = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
        let final = UIColor(red: 254/255, green: 219/255, blue: 191/255, alpha: 1.0)
        
        let gradient = CAGradientLayer(start: .bottomLeft, end: .center, colors: [final.cgColor, alpha.cgColor], type: .axial)
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
        
        bottomView.layer.cornerRadius = 10.0
        lblBonificacion.text = Validations.formatWith(Model.totalBonificacion)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - UIActions
    @IBAction func tap(_ sender: Any) {
        
        //Retirar:      50, 87
        //Tickets:      156, 87
        //Historial:    270, 87
        let btn = sender as! UIButton
        
        if btnSelected == btn.tag{
//            print("No mover")
            return
        }
        
        move(btn.tag)
    }
    
    //MARK: - HelperMethods
    func move(_ to: Int){
        
        var x = -1
        
        switch to {
        case ProcesoTag.Retirar.rawValue:
            btnSelected = ProcesoTag.Retirar.rawValue
            imgRetirar.alpha = 1.0
            imgTickets.alpha = 0.6
            imgHistorial.alpha = 0.6
            btnRetirar.setTitleColor(.white, for: .normal)
            btnTickets.setTitleColor(unselectedColor, for: .normal)
            btnHistorial.setTitleColor(unselectedColor, for: .normal)
            x = 50
        case ProcesoTag.Tickets.rawValue:
            btnSelected = ProcesoTag.Tickets.rawValue
            imgRetirar.alpha = 0.6
            imgTickets.alpha = 1.0
            imgHistorial.alpha = 0.6
            btnRetirar.setTitleColor(unselectedColor, for: .normal)
            btnTickets.setTitleColor(.white, for: .normal)
            btnHistorial.setTitleColor(unselectedColor, for: .normal)
            x = 156
        case ProcesoTag.Historico.rawValue:
            imgRetirar.alpha = 0.6
            imgTickets.alpha = 0.6
            imgHistorial.alpha = 1.0
            btnSelected = ProcesoTag.Historico.rawValue
            btnRetirar.setTitleColor(unselectedColor, for: .normal)
            btnTickets.setTitleColor(unselectedColor, for: .normal)
            btnHistorial.setTitleColor(.white, for: .normal)
            x = 270
        default:
            print("Error")
        }
        
        let frame = CGRect(x: CGFloat(x), y: indicatorView.frame.minY,
                           width: indicatorView.frame.width, height: indicatorView.frame.height)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.indicatorView.frame = frame
        }, completion: nil)
    }
    
}
