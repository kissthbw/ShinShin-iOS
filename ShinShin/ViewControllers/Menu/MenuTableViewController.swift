//
//  MenuTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/27/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin

class MenuTableViewController: UITableViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 374
        }
        else if indexPath.section == 1{
            return 48
        }
        else {//section 2
            return 222
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        if section == 1{
            return 4
        }
        else{ //section 2
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MenuHeaderCell
        //MenuOpcionesCell
        //MenuFooterCell
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderCell", for: indexPath) as! MenuHeaderTableViewCell
            cell.btnClose.addTarget(self, action: #selector(close), for: .touchUpInside)
            cell.btnSaldo.addTarget(self, action: #selector(retirarAction), for: .touchUpInside)
            cell.btnRetirar.addTarget(self, action: #selector(retirarAction), for: .touchUpInside)
            cell.btnTickets.addTarget(self, action: #selector(ticketAction), for: .touchUpInside)
            cell.btnHistorial.addTarget(self, action: #selector(historialAction), for: .touchUpInside)

            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuOpcionesCell", for: indexPath) as! MenuOpcionesTableViewCell
            
            cell.viewOption.layer.cornerRadius = 10.0
            
            switch indexPath.row {
            case 0:
                cell.imageOption.image = UIImage(named: "user-bold")
                cell.lblOption.text = "Perfil"
            case 1:
                cell.imageOption.image = UIImage(named: "money-bold-blue")
                cell.lblOption.text = "Cuentas de retiro"
            case 2:
                cell.imageOption.image = UIImage(named: "ayuda-bold-blue")
                cell.lblOption.text = "Ayuda"
            case 3:
                cell.imageOption.image = UIImage(named: "mail-bold-blue")
                cell.lblOption.text = "Contacto"
            default:
                cell.imageOption.image = UIImage(named: "user-bold")
            }

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuFooterCell", for: indexPath) as! MenuFooterTableViewCell
            cell.btnCerrarSesion.addTarget(self, action: #selector(cerrarSesionAction), for: .touchUpInside)
            cell.btnPrivacidad.addTarget(self, action: #selector(privacidadAction), for: .touchUpInside)
            
            return cell
        }
        
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 2{
            return nil
        }
        else{
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 0{
                performSegue(withIdentifier: "PerfilSegue", sender: indexPath)
            }
            if indexPath.row == 1{
                performSegue(withIdentifier: "CuentasRetiroSegue", sender: indexPath)
            }
            if indexPath.row == 2{
                performSegue(withIdentifier: "AyudaSegue", sender: indexPath)
            }
            if indexPath.row == 3{
                performSegue(withIdentifier: "ContactoSegue", sender: indexPath)
            }
        }
    }

    // MARK: - Navigation
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

//MARK: - Extension for MenuHeaderCell
extension MenuTableViewController{
    @objc func retirarAction(_ sender: Any) {
        performSegue(withIdentifier: "BonificacionSegue", sender: sender)
    }
    
    @objc func ticketAction(_ sender: Any) {
        performSegue(withIdentifier: "BonificacionSegue", sender: sender)
    }
    
    @objc func historialAction(_ sender: Any) {
        performSegue(withIdentifier: "BonificacionSegue", sender: sender)
    }
    
    
    @objc func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Extension for MenuOpcionesCell
extension MenuTableViewController{
}

//MARK: - Extension for MenuFooterCell
extension MenuTableViewController{
    @objc func cerrarSesionAction(_ sender: Any) {
        if let id = Model.idRedSocial{
            if id == 1{
                GIDSignIn.sharedInstance().signOut()
            }
            else if id == 2{
                let loginManager = LoginManager()
                loginManager.logOut()
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "LogOutSegue", sender: self)
    }
    
    @objc func privacidadAction(_ sender: Any) {
        performSegue(withIdentifier: "PrivacidadSegue", sender: sender)
    }
}
