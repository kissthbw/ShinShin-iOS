//
//  MenuViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/24/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin

class MenuViewController: UIViewController {

    //MARK: - Propiedades
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewPerfil: UIView!
    @IBOutlet weak var viewRetiro: UIView!
    @IBOutlet weak var viewAyuda: UIView!
    @IBOutlet weak var viewContacto: UIView!
    
    @IBOutlet weak var viewIconoUser: UIView!
    @IBOutlet weak var btnRetirar: UIButton!
    @IBOutlet weak var btnTickets: UIButton!
    @IBOutlet weak var btnHistorial: UIButton!
    @IBOutlet weak var lblBonificacion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewUser.layer.cornerRadius = 35.0
        viewIconoUser.layer.cornerRadius = viewIconoUser.frame.width / 2
        viewPerfil.layer.cornerRadius = 10.0
        viewRetiro.layer.cornerRadius = 10.0
        viewAyuda.layer.cornerRadius = 10.0
        viewContacto.layer.cornerRadius = 10.0
        
        lblBonificacion.text = Validations.formatWith(Model.totalBonificacion)
        btnRetirar.layer.cornerRadius = 20.0
        btnRetirar.tag = 1
        
        btnTickets.layer.cornerRadius = 20.0
        btnTickets.tag = 2
        
        btnHistorial.layer.cornerRadius = 20.0
        btnHistorial.tag = 3
        
    }
    
    //MARK: - Actions
    @IBAction func retirarAction(_ sender: Any) {
        performSegue(withIdentifier: "BonificacionSegue", sender: sender)
    }
    
    @IBAction func ticketAction(_ sender: Any) {
        performSegue(withIdentifier: "BonificacionSegue", sender: sender)
    }
    
    @IBAction func historialAction(_ sender: Any) {
        performSegue(withIdentifier: "BonificacionSegue", sender: sender)
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Agregar animacion de salida
    @IBAction func cerrarSesionAction(_ sender: Any) {
        
        if let id = Model.idRedSocial{
            if id == -1{
                Model.logout = true
                Model.resetUsuario()
            }
            else if id == 1{
                GIDSignIn.sharedInstance().signOut()
                Model.logout = true
            }
            else if id == 2{
                let loginManager = LoginManager()
                loginManager.logOut()
                Model.logout = true
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
//        self.performSegue(withIdentifier: "LogOutSegue", sender: self)
//        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "LogInViewController")
//
//        self.present(destViewController, animated: true, completion: nil)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BonificacionSegue"{
            let vc = segue.destination as! BonificacionViewController
            let button = sender as! UIButton
            
            if button.tag == 1{
                vc.tipoProceso = .Retirar
            }
            else if button.tag == 2{
                vc.tipoProceso = .Tickets
            }
            else if button.tag == 3{
                vc.tipoProceso = .Historico
            }
        }
        
        if segue.identifier == "PrivacidadSegue"{
            let vc = segue.destination as! PrivacidadViewController
            vc.origen = .Menu
        }
    }

}
