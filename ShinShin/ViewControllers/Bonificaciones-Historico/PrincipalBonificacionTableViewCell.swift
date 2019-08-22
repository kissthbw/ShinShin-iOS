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
    @IBOutlet weak var lblBonificacion: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var btnRetirar: UIButton!
    @IBOutlet weak var btnTickets: UIButton!
    @IBOutlet weak var btnHistorial: UIButton!
    @IBOutlet weak var indicatorView: UIImageView!
    
    enum ProcesoTag: Int {
        case Retirar = 1, Tickets, Historico
    }
    
    var btnSelected = ProcesoTag.Retirar.rawValue
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnRetirar.tag = ProcesoTag.Retirar.rawValue
        btnTickets.tag = ProcesoTag.Tickets.rawValue
        btnHistorial.tag = ProcesoTag.Historico.rawValue
        
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
            print("No mover")
            return
        }
        
        var x = -1
        
        switch btn.tag {
        case ProcesoTag.Retirar.rawValue:
            btnSelected = ProcesoTag.Retirar.rawValue
            x = 50
        case ProcesoTag.Tickets.rawValue:
            btnSelected = ProcesoTag.Tickets.rawValue
            x = 156
        case ProcesoTag.Historico.rawValue:
            btnSelected = ProcesoTag.Historico.rawValue
            x = 270
        default:
            print("Error")
        }
//        print("Button selected: \(sender)")
        moveFrom(x)
    }
    
    //MARK: - HelperMethods
    func moveFrom(_ to: Int){
        
        let frame = CGRect(x: CGFloat(to), y: indicatorView.frame.minY,
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
