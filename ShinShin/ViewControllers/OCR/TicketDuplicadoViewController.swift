//
//  TicketDuplicadoViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 8/8/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol TicketDuplicadoViewControllerDelegate: class{
    func didCompleted(_ controller: TicketDuplicadoViewController)
}

class TicketDuplicadoViewController: UIViewController {

    @IBOutlet weak var btnIntentar: UIButton!
    
    weak var delegate: TicketDuplicadoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnIntentar.layer.cornerRadius = 10.0
    }
    

    @IBAction func OKAction(_ sender: Any) {
        delegate?.didCompleted(self)
    }

}
