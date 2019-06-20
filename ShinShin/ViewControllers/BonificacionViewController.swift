//
//  BonificacionViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BonificacionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var isMenuVisible = false
    enum Proceso {
        case Retirar
        case Tickets
        case Historico
        
    }
    
    enum SubProceso{
        case NoSeleccionado
        case BanificacionBanco
        case BanificacionPayPal
        case BanificacionRecarga
    }
    var selectedRow = -1
    var previousSelectedRow = -1
    var tipoProceso: Proceso = .Historico
    var tipoSubProceso: SubProceso = .NoSeleccionado

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBarButtons()
    }
    
    //MARK: - UIActions
    @IBAction func showHistorialAction(_ sender: Any) {
        tipoProceso = .Historico
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
    }
    
    @IBAction func showTicketsAction(_ sender: Any) {
        tipoProceso = .Tickets
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
    }
    
    @IBAction func showRetirarAction(_ sender: Any) {
        tipoProceso = .Retirar
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
    }
    
    //MARK: - Helper methods
    func configureBarButtons(){
        let notif = UIBarButtonItem(
            image: UIImage(named: "notif_placeholder"),
            style: .plain,
            target: self,
            action: #selector(showNotif))
        notif.tintColor = .black
        
        let user = UIBarButtonItem(
            image: UIImage(named: "user_placeholder"),
            style: .plain,
            target: self,
            action: #selector(showMenu))
        user.tintColor = .black
        navigationItem.rightBarButtonItems = [user, notif]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BonificacionViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tipoProceso == .Historico{
            return 60
        }
        else if tipoProceso == .Tickets{
            return 60
        }
        else{
            if tipoSubProceso == .BanificacionBanco && indexPath.row == selectedRow{
                return 360
            }
            if tipoSubProceso == .BanificacionPayPal && indexPath.row == selectedRow{
                return 360
            }
            if tipoSubProceso == .BanificacionRecarga && indexPath.row == selectedRow{
                return 400
            }
            else{
                return 88
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tipoProceso == .Historico{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoBonificacionCell", for: indexPath) as! HistoricoBonificacionTableViewCell
            
            cell.lblTipo.text = "Paq. móvil"
            cell.lblFecha.text = "03/06/2019"
            cell.lblCantidad.text = "$ 100.00"
            //        cell.imageView?.image = UIImage(named: "img_placeholder")
            
            return cell
        }
        else if tipoProceso == .Tickets{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoTicketCell", for: indexPath)
            
            return cell
        }
        else{
            if tipoSubProceso == .BanificacionBanco && indexPath.row == selectedRow{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "BancoBonificacionCell", for: indexPath)
                //                cell.lblTitulo.text = "PayPal"
                return cell
                
            }
           else  if tipoSubProceso == .BanificacionPayPal && indexPath.row == selectedRow{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalBonificacionCell", for: indexPath)
                //                cell.lblTitulo.text = "PayPal"
                return cell
                
            }
            else if tipoSubProceso == .BanificacionRecarga && indexPath.row == selectedRow{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaBonificacionCell", for: indexPath)
                //                cell.lblTitulo.text = "PayPal"
                return cell
                
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
                if indexPath.row == 0{
                    cell.lblTitulo.text = "Bancaria"
                }
                else if indexPath.row == 1{
                    cell.lblTitulo.text = "PayPal"
                }
                else{
                    cell.lblTitulo.text = "Recarga telefónica"
                }
                
                return cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tipoProceso == .Retirar{
            
            if indexPath.row == 0{
                tipoSubProceso = .BanificacionBanco
            }
            
            if indexPath.row == 1{
                tipoSubProceso = .BanificacionPayPal
            }
            if indexPath.row == 2{
                tipoSubProceso = .BanificacionRecarga
            }

            
            
            
            //Caso inicial: No existen celdas seleccionadas, se selecciona una
            //celda y se expande
            //Caso 2: Ya existe una celda seleccionada, cuya posicion esta
            //almacenada en selectedRow, se debe cerrar se celda previa y expandir
            //la nueva celda
            if selectedRow == -1{
                selectedRow = indexPath.row
            }
            else if selectedRow == indexPath.row{
                selectedRow = -1
                previousSelectedRow = -1
            }
            else{
                previousSelectedRow = selectedRow
                selectedRow = indexPath.row
            }
            
//            var indexPaths = [IndexPath]()
            let index = IndexPath(row: indexPath.row, section: indexPath.section)
            
            if previousSelectedRow != -1{
                let item = IndexPath(row: previousSelectedRow, section: indexPath.section)
//                indexPaths.append(item)
                tableView.reloadRows(at: [item], with: .fade)
            }
//            indexPaths.append(index)
            
            tableView.reloadRows(at: [index], with: .fade)
//            tableView.reloadSections(IndexSet(integersIn: 0...0), with: .right)
        }
    }
}

extension BonificacionViewController: SideMenuDelegate{
    
    func closeMenu() {
        isMenuVisible = !isMenuVisible
        let viewMenuBack : UIView = (self.navigationController?.view.subviews.last)!
        //            let viewMenuBack : UIView = view.subviews.last!
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = UIScreen.main.bounds.size.width
            viewMenuBack.frame = frameMenu
            viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            viewMenuBack.removeFromSuperview()
        })
    }
    
    @objc
    func showNotif(){
        openViewControllerBasedOnIdentifier("NotificacionesTableViewController")
    }
    
    @objc
    func showMenu(){
        
        if isMenuVisible{
            isMenuVisible = !isMenuVisible
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
        }
        else{
            isMenuVisible = !isMenuVisible
            let menuVC : SideMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewControllerOK") as! SideMenuViewController
            //        menuVC.btnMenu = sender
            menuVC.delegate = self
            self.view.addSubview(menuVC.view)
            self.addChild(menuVC)
            menuVC.view.layoutIfNeeded()
            menuVC.view.layer.shadowRadius = 2.0
            
            
            menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                menuVC.view.frame=CGRect(x: 100, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                //            sender.isEnabled = true
            }, completion:nil)
        }
        
        
    }
    
    func sideMenuItemSelectedAtIndex(_ index: Int) {
        isMenuVisible = !isMenuVisible
        
        switch(index){
        case 1:
            self.openViewControllerBasedOnIdentifier("PerfilTableViewController")
            break
        case 2: self.openViewControllerBasedOnIdentifier("MediosBonificacionTableViewController")
        case 3:
            self.openViewControllerBasedOnIdentifier("AyudaViewControlller")
        case 4:
            self.openViewControllerBasedOnIdentifier("ContactoViewController")
            break
        case 5:
            self.openViewControllerBasedOnIdentifier("BonificacionViewController")
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
}
