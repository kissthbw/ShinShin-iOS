//
//  BonificacionViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class BonificacionViewController: UIViewController {
    
    //MARK: - Propiedades
    @IBOutlet weak var tableView: UITableView!
    
    var tmpCell: UITableViewCell?
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
    
    //MARK: - Actions
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
        let img = UIImage(named: "money-grey")
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 4, y: 6, width: 22, height: 22)
        
        let lblBonificacion = UILabel()
        lblBonificacion.font = UIFont(name: "Nunito SemiBold", size: 17)
        lblBonificacion.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        lblBonificacion.text = "$ 10.00"
        lblBonificacion.sizeToFit()
        let frame = lblBonificacion.frame
        lblBonificacion.frame = CGRect(x: 27, y: 6, width: frame.width, height: frame.height)
        
        //El tamanio del view debe ser
        //lblBonificacion.width + imageView.x + imageView.width + 4(que debe ser lo mismo que imageView.x
        let width = lblBonificacion.frame.width + imageView.frame.minX +
            imageView.frame.width + imageView.frame.minX
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 32))
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0).cgColor
        view.addSubview(imageView)
        view.addSubview(lblBonificacion)
        
        self.navigationItem.titleView = view
        
        let home = UIBarButtonItem(
            image: UIImage(named: "logo-menu"),
            style: .plain,
            target: self,
            action: #selector(showHome))
        home.tintColor = .black
        
        let notif = UIBarButtonItem(
            image: UIImage(named: "bar-notif-grey"),
            style: .plain,
            target: self,
            action: #selector(showNotif))
        notif.tintColor = .black
        
        let user = UIBarButtonItem(
            image: UIImage(named: "bar-user-grey"),
            style: .plain,
            target: self,
            action: #selector(showMenu))
        user.tintColor = .black
        navigationItem.rightBarButtonItems = [user, notif]
        navigationItem.leftBarButtonItems = [home]
    }
    
    @objc
    func showHome(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func showNotif(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showMenu(){
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    @objc func guardarItem(){
        print("Guardando solicitud de bonificacion")
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

//MARK: - Extensions
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
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "BancoBonificacionCell", for: indexPath) as! BonificacionTableViewCell
                
                tmpCell = cell
                //                cell.lblTitulo.text = "PayPal"
                return cell
                
            }
           else  if tipoSubProceso == .BanificacionPayPal && indexPath.row == selectedRow{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalBonificacionCell", for: indexPath) as! BonificacionTableViewCell
                //                cell.lblTitulo.text = "PayPal"
                tmpCell = cell
                return cell
                
            }
            else if tipoSubProceso == .BanificacionRecarga && indexPath.row == selectedRow{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaBonificacionCell", for: indexPath) as! BonificacionTableViewCell
                tmpCell = cell
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
