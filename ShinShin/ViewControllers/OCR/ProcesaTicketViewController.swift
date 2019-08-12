//
//  ProcesaTicketViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/12/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol ProcesaTicketViewControllerDelegate: class{
    func didCompleted(_ controller: ProcesaTicketViewController)
}

class ProcesaTicketViewController: UIViewController {

    @IBOutlet weak var lblMensaje: UILabel!
    
    var total: Double?
    weak var delegate: ProcesaTicketViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let total = total{
            let mensaje = "Sumaste " + Validations.formatWith(total) + " a tu saldo, ¡Sigue así!"
            lblMensaje.text = mensaje
        }
    }
    
    @IBAction func OKAction(_ sender: Any) {
        delegate?.didCompleted(self)
    }
}
