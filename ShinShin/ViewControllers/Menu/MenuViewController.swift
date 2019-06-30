//
//  MenuViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/24/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    //MARK: - Propiedades
    @IBOutlet weak var btnRetirar: UIButton!
    @IBOutlet weak var btnHistorial: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRetirar.layer.cornerRadius = 10
        btnHistorial.layer.cornerRadius = 10
    }
    
    //MARK: - Actions
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Agregar animacion de salida
    @IBAction func cerrarSesionAction(_ sender: Any) {
        self.performSegue(withIdentifier: "LogOutSegue", sender: self)
//        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "LogInViewController")
//
//        self.present(destViewController, animated: true, completion: nil)
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
