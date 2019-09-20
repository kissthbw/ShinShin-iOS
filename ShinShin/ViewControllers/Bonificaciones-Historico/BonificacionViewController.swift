//
//  BonificacionViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

enum Proceso: Int {
    case Retirar = 1
    case Tickets = 2
    case Historico = 3
    
}

enum SubProceso{
    case NoSeleccionado
    case BanificacionBanco
    case BanificacionPayPal
    case BanificacionRecarga
}

class BonificacionViewController: UIViewController {
    
    //MARK: - Propiedades
    @IBOutlet weak var tableView: UITableView!
    
    let ID_RQT_TICKETS = "ID_RQT_TICKETS"
    let ID_RQT_BONIFICACIONES = "ID_RQT_BONIFICACIONES"
    let ID_RQT_CATALOGO = "ID_RQT_CATALOGO"
    
    var primeraVez = true
    
    //Arreglo de historico de tickets
    var bonificaciones = [Bonificacion]()
    
    //Arreglo de historico de bonificaciones
    var tickets = [Ticket]()
    
    //Arreglo para obtener la lista de medios de bonificacion
    //del usuario
    var medios: MediosBonificacionRSP = MediosBonificacionRSP()
    
    var tmpCell: UITableViewCell?
    var isMenuVisible = false
    
    var selectedRow = -1
    var previousSelectedRow = -1
    var tipoProceso: Proceso = .Retirar
    var tipoSubProceso: SubProceso = .NoSeleccionado

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()
//
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
        
        configureBarButtons()
        catalogoMediosRequest()
        
        var cellNib = UINib(nibName: "TicketNotFound", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "TicketNotFoundCell")
        
        cellNib = UINib(nibName: "HistoricoNotFound", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "HistoricoNotFoundCell")
        
        
        if tipoProceso == .Retirar{
            tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
        }
        else if tipoProceso == .Tickets{
            obtieneHistoricoTicketsRequest()
        }
        else if tipoProceso == .Historico{
            obtieneHistoricoBonificacionesRequest()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
//    override func willMove(toParent parent: UIViewController?) {
//        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.isTranslucent = true
//    }
    
    //MARK: - Actions
    @IBAction func showHistorialAction(_ sender: Any) {
        tipoProceso = .Historico
//        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
        obtieneHistoricoBonificacionesRequest()
    }
    
    @IBAction func showTicketsAction(_ sender: Any) {
        tipoProceso = .Tickets
        obtieneHistoricoTicketsRequest()
    }
    
    @IBAction func showRetirarAction(_ sender: Any) {
        tipoProceso = .Retirar
        tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
    }
    
    //MARK: - Helper methods
    func configureBarButtons(){
        
        let home = UIBarButtonItem(
            image: UIImage(named: "logo-menu"),
            style: .plain,
            target: self,
            action: #selector(showHome))
        home.tintColor = .white
        
        let notif = UIBarButtonItem(
            image: UIImage(named: "bar-notif-white"),
            style: .plain,
            target: self,
            action: #selector(showNotif))
        notif.tintColor = .white
        
        let user = UIBarButtonItem(
            image: UIImage(named: "menu-white"),
            style: .plain,
            target: self,
            action: #selector(showMenu))
        user.tintColor = .white
        self.navigationItem.rightBarButtonItems = [user, notif]
        self.navigationItem.leftBarButtonItems = [home]
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
        present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
    }
    
    func obtieneHistoricoTicketsRequest(){
        do{
            let encoder = JSONEncoder()
            let user = Usuario()
            user.idUsuario = Model.user?.idUsuario
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.obtieneHistoricoTickets, with: json, and: ID_RQT_TICKETS)
        }
        catch{
            
        }
    }
    
    func obtieneHistoricoBonificacionesRequest(){
        do{
            let encoder = JSONEncoder()
            let user = Usuario()
            user.idUsuario = Model.user?.idUsuario
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.obtieneHistoricoBonificaciones, with: json, and: ID_RQT_BONIFICACIONES)
        }
        catch{
            
        }
    }
    
    func catalogoMediosRequest(){
        do{
            let encoder = JSONEncoder()
            let user = Usuario()
            user.idUsuario = Model.user?.idUsuario
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.obtieneMediosBonificacionPorUsuario, with: json, and: ID_RQT_CATALOGO)
        }
        catch{
            
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SolicitarBonificacionSegue"{
            let row = sender as! Int
            print("Selected row: \(row)")
            
            let vc = segue.destination as! SolicitarBonificacionTableViewController
            vc.medios = medios
            if row == 0{
                vc.tipoRetiro = .Bancario
            }
            else if row == 1{
                vc.tipoRetiro = .PayPal
            }
            else{
                vc.tipoRetiro = .Telefonica
            }
            
        }
        
        if segue.identifier == "DetalleTicketSegue"{
            let indexPath = sender as! IndexPath
            let vc = segue.destination as! TicketDetailTableViewController
            vc.idTicket = indexPath.row
        }
    }

}

//MARK: - Extensions
extension BonificacionViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 250
        }
        else{
            if tipoProceso == .Historico{
                if bonificaciones.count == 0{
                    return 500
                }
                return 40
            }
            else if tipoProceso == .Tickets{
                if tickets.count == 0{
                    return 500
                }
                return 40
            }
            else{
                if tipoSubProceso == .BanificacionBanco && indexPath.row == selectedRow{
                    return 360
                }
                else if tipoSubProceso == .BanificacionPayPal && indexPath.row == selectedRow{
                    return 360
                }
                else if tipoSubProceso == .BanificacionRecarga && indexPath.row == selectedRow{
                    return 400
                }
                else if indexPath.section == 1 && indexPath.row == 3{
                    return 120
                }
                else{
                    return 88
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }
        else{
            if tipoProceso == .Historico{
                if bonificaciones.count == 0{
                    return 1
                }
                
                return bonificaciones.count
            }
            else if tipoProceso == .Tickets{
                if tickets.count == 0{
                    return 1
                }
                return tickets.count
            }
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tipoProceso == .Historico && section == 1 && bonificaciones.count > 0{
            let header = Bundle.main.loadNibNamed("HistoricoBonificacionHeaderCell", owner: nil, options: nil)!.first as! UIView
            
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tipoProceso == .Historico && section == 1  && bonificaciones.count > 0{
            return 36
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Configuracion para cell principal
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrincipalBonificacionCell", for: indexPath) as! PrincipalBonificacionTableViewCell
           cell.lblBonificacion.text = Validations.formatWith(Model.totalBonificacion)
            
            if primeraVez{
                cell.move( tipoProceso.rawValue )
                primeraVez = false
            }
            
            return cell
        }
        else{
            //Section 2
            if tipoProceso == .Historico{
                
                if bonificaciones.count == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoNotFoundCell", for: indexPath) as! HistoricoNotFoundTableViewCell
                    
                    return cell
                }
                else{
                    let item = bonificaciones[indexPath.row]
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoBonificacionCell", for: indexPath) as! HistoricoBonificacionTableViewCell
                    
                    cell.lblTipo.text = item.mediosBonificacion?.aliasMedioBonificacion
                    cell.lblFecha.text = item.fechaBonificacion
                    cell.lblCantidad.text = Validations.formatWith(item.cantidadBonificacion)
                    
                    return cell
                }
            }//Termina Hitorico
            else if tipoProceso == .Tickets{
                
                if tickets.count == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TicketNotFoundCell", for: indexPath) as! TicketNotFoundTableViewCell
                    
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoTicketCell", for: indexPath) as! HistoricoTicketTableViewCell
                    
                    //Mostrar cell cuando no hay tickets
                    let item = tickets[indexPath.row]
                    cell.lblTienda.text = item.nombreTienda
                    cell.lblFecha.text = item.fecha
                    cell.lblCantidad.text = Validations.formatWith(item.total)
                    
                    return cell
                }
            }//Termina Tickets
            else{
                //Para los casos de Proceso == retirar
                if indexPath.row == 0{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
                        cell.icon.image = UIImage(named: "retiroBnacario")
                        cell.lblTitulo.text = "Bancaria"
                        cell.btnArrow.tag = indexPath.row
                        cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                        
                        return cell
                }
                else if indexPath.row == 1{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
                        cell.icon.image = UIImage(named: "retiroPayPal")
                        cell.lblTitulo.text = "PayPal"
                        cell.btnArrow.tag = indexPath.row
                        cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                        
                        return cell
                }
                else if indexPath.row == 2{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
                        cell.icon.image = UIImage(named: "recargaTelefonica")
                        cell.lblTitulo.text = "Recarga telefónica"
                        cell.btnArrow.tag = indexPath.row
                        cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                        
                        return cell
                }
                else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
                        
                        return cell
                    
                }

            }
        }
        
    }
    
    @objc
    func selectBonificacionTableViewCell(_ sender: Any){
        
        let button = sender as! UIButton
        let row = button.tag
        performSegue(withIdentifier: "SolicitarBonificacionSegue", sender: row)
//        updateCellRetirar(row)
    }
    
    func updateCellRetirar(_ row: Int){
        if tipoProceso == .Retirar{
            
            if row == 0{
                tipoSubProceso = .BanificacionBanco
            }
            
            if row == 1{
                tipoSubProceso = .BanificacionPayPal
            }
            if row == 2{
                tipoSubProceso = .BanificacionRecarga
            }
            
            //Caso inicial: No existen celdas seleccionadas, se selecciona una
            //celda y se expande
            //Caso 2: Ya existe una celda seleccionada, cuya posicion esta
            //almacenada en selectedRow, se debe cerrar se celda previa y expandir
            //la nueva celda
            if selectedRow == -1{
                selectedRow = row
            }
            else if selectedRow == row{
                selectedRow = -1
                previousSelectedRow = -1
            }
            else{
                previousSelectedRow = selectedRow
                selectedRow = row
            }
            
            //            var indexPaths = [IndexPath]()
            let index = IndexPath(row: row, section: 1)
            
            if previousSelectedRow != -1{
                let item = IndexPath(row: previousSelectedRow, section: 1)
                //                indexPaths.append(item)
                tableView.reloadRows(at: [item], with: .fade)
            }
            //            indexPaths.append(index)
            
            tableView.reloadRows(at: [index], with: .fade)
            //            tableView.reloadSections(IndexSet(integersIn: 0...0), with: .right)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && tipoProceso == .Tickets{
            return indexPath
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && tipoProceso == .Tickets{
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "DetalleTicketSegue", sender: indexPath)
        }
    }
}

//MARK: - RESTActionDelegate
extension BonificacionViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        if identifier == ID_RQT_TICKETS{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(HistoricoTicket.self, from: data)
                if rsp.code == 200{
                    if let items = rsp.tickets{
                        tickets = items
                        tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
                    }
                    else{
                        tickets = [Ticket]()
                        tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
                    }
                }
                
            }
            catch{
                print("JSON Error: \(error)")
            }
        }
        else if identifier == ID_RQT_BONIFICACIONES{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(HistoricoBonificacion.self, from: data)
                
                if rsp.code == 200{
                    
                    if let items = rsp.historicoMediosBonificaciones{
                        bonificaciones = items
                        tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
                    }
                    else{
                        bonificaciones = [Bonificacion]()
                        tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
                    }
                }
                
            }
            catch{
                print("JSON Error: \(error)")
            }
        }
        else if identifier == ID_RQT_CATALOGO{
            do{
                let decoder = JSONDecoder()
                
                //El arreglo de medios se mostrara solo cuando se quiara seleccionar un medio
                medios = try decoder.decode(MediosBonificacionRSP.self, from: data)
                
            }
            catch{
                print("JSON Error: \(error)")
            }
        }
    }
    
    func restActionDidError() {
        self.showNetworkError()
    }
    
    func showNetworkError(){
        let alert = UIAlertController(
            title: "Whoops...",
            message: "Ocurrió un problema." +
            " Favor de interntar nuevamente",
            preferredStyle: .alert)
        
        let action =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
