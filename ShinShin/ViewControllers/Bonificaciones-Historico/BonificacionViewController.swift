//
//  BonificacionViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

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

class BonificacionViewController: UIViewController {
    
    //MARK: - Propiedades
//    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let ID_RQT_BONIFICACION = "ID_RQT_BONIFICACION"
    let ID_RQT_TICKETS = "ID_RQT_TICKETS"
    let ID_RQT_BONIFICACIONES = "ID_RQT_BONIFICACIONES"
    let ID_RQT_CATALOGO = "ID_RQT_CATALOGO"
    
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
    var tipoProceso: Proceso = .Historico
    var tipoSubProceso: SubProceso = .NoSeleccionado

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
//        viewBottom.layer.cornerRadius = 10.0
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
//        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
        configureBarButtons()
        catalogoMediosRequest()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
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
            image: UIImage(named: "bar-user-white"),
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
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    @objc func guardarItem(){
        if tipoSubProceso == .BanificacionBanco{
            
            if let cell = tmpCell as? BancoBonificacionTableViewCell{
                print("Guardando solicitud de bonificacion")
                let item = Bonificacion()
                
                item.cantidadBonificacion = Double( cell.txtCantidad.text! )
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let fecha = formatter.string(from: date)
                item.fechaBonificacion = fecha
                
                formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
                let hora = formatter.string(from: date)
//                item.horaBonificacion = hora
                
                let medio = MediosBonificacion()
                medio.idMediosBonificacion = cell.cuenta?.idMediosBonificacion
                
                let user = Usuario()
                user.idUsuario = Model.user?.idUsuario
                
                item.mediosBonificacion = medio
                item.usuario = user
                
                guardarBonificacionRequest(with: item)
            }
            
            
        }
        else if tipoSubProceso == .BanificacionPayPal{
            if let cell = tmpCell as? PayPalBonificacionTableViewCell{
                print("Guardando solicitud de PayPal")
                
                let item = Bonificacion()
                
                item.cantidadBonificacion = Double( cell.txtCantidad.text! )
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let fecha = formatter.string(from: date)
                item.fechaBonificacion = fecha
                
                formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
                let hora = formatter.string(from: date)
//                item.horaBonificacion = hora
                
                let medio = MediosBonificacion()
                medio.idMediosBonificacion = cell.cuenta?.idMediosBonificacion
                
                let user = Usuario()
                user.idUsuario = Model.user?.idUsuario
                
                item.mediosBonificacion = medio
                item.usuario = user
                
                guardarBonificacionRequest(with: item)
            }
            
        }
        else if tipoSubProceso == .BanificacionRecarga{
            if let cell = tmpCell as? RecargaBonificacionTableViewCell{
                print("Guardando solicitud de Recarga")
                
                let item = Bonificacion()
                
                item.cantidadBonificacion = Double( cell.txtCantidad.text! )
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let fecha = formatter.string(from: date)
                item.fechaBonificacion = fecha
                
                formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
                let hora = formatter.string(from: date)
//                item.horaBonificacion = hora
                
                let medio = MediosBonificacion()
                medio.idMediosBonificacion = cell.cuenta?.idMediosBonificacion
                
                let user = Usuario()
                user.idUsuario = Model.user?.idUsuario
                
                item.mediosBonificacion = medio
                item.usuario = user
                
                guardarBonificacionRequest(with: item)
            }
        }
        
    }
    
    func guardarBonificacionRequest(with item: Bonificacion){
        do{
            let encoder = JSONEncoder()
            
            let json = try encoder.encode(item)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.guardarBonificacion, with: json, and: ID_RQT_BONIFICACION)
        }
        catch{
            
        }
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConformacionSegue"{
            let vc = segue.destination as! ConfirmacionBonificacionViewController
            
            vc.tipoSubProceso = tipoSubProceso
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
                return 60
            }
            else if tipoProceso == .Tickets{
                return 60
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
                return bonificaciones.count
            }
            else if tipoProceso == .Tickets{
                return tickets.count
            }
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tipoProceso == .Historico && section == 1{
            let header = Bundle.main.loadNibNamed("HistoricoBonificacionHeaderCell", owner: nil, options: nil)!.first as! UIView
            
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tipoProceso == .Historico && section == 1{
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
            return cell
        }
        else{
            //Section 2
            if tipoProceso == .Historico{
                
                let item = bonificaciones[indexPath.row]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoBonificacionCell", for: indexPath) as! HistoricoBonificacionTableViewCell
                
                cell.lblTipo.text = item.mediosBonificacion?.aliasMedioBonificacion
                cell.lblFecha.text = item.fechaBonificacion
                cell.lblCantidad.text = Validations.formatWith(item.cantidadBonificacion)
                
                return cell
            }//Termina Hitorico
            else if tipoProceso == .Tickets{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoTicketCell", for: indexPath) as! HistoricoTicketTableViewCell
                
                let item = tickets[indexPath.row]
                cell.lblTienda.text = item.nombreTienda
                cell.lblFecha.text = item.fecha
                cell.lblCantidad.text = Validations.formatWith(item.total)
                
                return cell
            }//Termina Tickets
            else{
                //Para los casos de Proceso == retirar
                if tipoSubProceso == .BanificacionBanco && indexPath.row == selectedRow{
                    
                    let cuentas = medios.mediosBonificacion?[0].list
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "BancoBonificacionCell", for: indexPath) as! BancoBonificacionTableViewCell
                    cell.cuentas = cuentas
                    cell.btnArrow.tag = indexPath.row
                    cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                    cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
                    tmpCell = cell
                    
                    return cell
                    
                }
                else  if tipoSubProceso == .BanificacionPayPal && indexPath.row == selectedRow{
                    let cuentas = medios.mediosBonificacion?[1].list
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalBonificacionCell", for: indexPath) as! PayPalBonificacionTableViewCell
                    cell.cuentas = cuentas
                    cell.btnArrow.tag = indexPath.row
                    cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                    cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
                    tmpCell = cell
                    
                    return cell
                    
                }
                else if tipoSubProceso == .BanificacionRecarga && indexPath.row == selectedRow{
                    let cuentas = medios.mediosBonificacion?[2].list
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaBonificacionCell", for: indexPath) as! RecargaBonificacionTableViewCell
                    cell.cuentas = cuentas
                    cell.btnArrow.tag = indexPath.row
                    cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                    cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
                    tmpCell = cell
                    //                cell.lblTitulo.text = "PayPal"
                    return cell
                    
                }
                else{
                    if indexPath.row == 0{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
                        
                        cell.lblTitulo.text = "Bancaria"
                        cell.btnArrow.tag = indexPath.row
                        cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                        
                        return cell
                    }
                    else if indexPath.row == 1{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
                        
                        cell.lblTitulo.text = "PayPal"
                        cell.btnArrow.tag = indexPath.row
                        cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                        
                        return cell
                    }
                    else if indexPath.row == 2{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
                        
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
        
    }
    
    @objc
    func selectBonificacionTableViewCell(_ sender: Any){
        
        let button = sender as! UIButton
        let row = button.tag
        
        updateCellRetirar(row)
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
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK: - RESTActionDelegate
extension BonificacionViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        if identifier == ID_RQT_BONIFICACION{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(InformacionUsuario.self, from: data)
                if rsp.code == 200{
                    print("Solicitud guardada con exito")
                    Model.totalBonificacion = rsp.bonificacion
                    //Actualizar tableView ha estado inicial
                    tipoProceso = .Retirar
                    updateCellRetirar(selectedRow)
                    tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
                    performSegue(withIdentifier: "ConformacionSegue", sender: self)
                }
                
            }
            catch{
                print("JSON Error: \(error)")
            }
        }
        else if identifier == ID_RQT_TICKETS{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(HistoricoTicket.self, from: data)
                if rsp.code == 200{
                    tickets = rsp.tickets
                    tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
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
                
//                if rsp.code == 200{
                    bonificaciones = rsp.historicoMediosBonificaciones
                tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
//                }
                
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
