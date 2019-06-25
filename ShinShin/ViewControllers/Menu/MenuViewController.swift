//
//  MenuViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/24/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HistoricoSegue"{
            let vc = segue.destination as! BonificacionViewController
            vc.tipoProceso = .Historico
        }
        
        if segue.identifier == "RetirosSegue"{
            let vc = segue.destination as! BonificacionViewController
            vc.tipoProceso = .Retirar
        }
    }

}
