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
    let ID_RQT_BONIFICACION = "ID_RQT_BONIFICACION"
    let ID_RQT_TICKETS = "ID_RQT_TICKETS"
    let ID_RQT_BONIFICACIONES = "ID_RQT_BONIFICACIONES"
    
    //Arreglo de historico de tickets
    var bonificaciones = [Bonificacion]()
    
    //Arreglo de historico de bonificaciones
    var tickets = [Ticket]()
    
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
//        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
        obtieneHistoricoBonificacionesRequest()
    }
    
    @IBAction func showTicketsAction(_ sender: Any) {
        tipoProceso = .Tickets
        obtieneHistoricoTicketsRequest()
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
                medio.idMediosBonificacion = 2
                
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
                medio.idMediosBonificacion = 2
                
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
                medio.idMediosBonificacion = 2
                
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
        if tipoProceso == .Historico{
            return bonificaciones.count
        }
        else if tipoProceso == .Tickets{
            return tickets.count
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tipoProceso == .Historico{
            
            let item = bonificaciones[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoBonificacionCell", for: indexPath) as! HistoricoBonificacionTableViewCell
            
            cell.lblTipo.text = item.mediosBonificacion?.aliasMedioBonificacion
            cell.lblFecha.text = item.fechaBonificacion
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let tmp = NSNumber(value: item.cantidadBonificacion!)
            if let bon = formatter.string(from: tmp){
//                cell.lblBonificacion.text = "$ \(bon)"
                cell.lblCantidad.text = bon
            }
            //        cell.imageView?.image = UIImage(named: "img_placeholder")
            
            return cell
        }
        else if tipoProceso == .Tickets{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoTicketCell", for: indexPath) as! HistoricoTicketTableViewCell
            
            let item = tickets[indexPath.row]
            cell.lblTienda.text = item.nombreTienda
            cell.lblFecha.text = item.fecha
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let tmp = NSNumber(value: item.total!)
            if let bon = formatter.string(from: tmp){
                cell.lblCantidad.text = bon
            }
            
            return cell
        }
        else{
            if tipoSubProceso == .BanificacionBanco && indexPath.row == selectedRow{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "BancoBonificacionCell", for: indexPath) as! BancoBonificacionTableViewCell
                cell.btnArrow.tag = indexPath.row
                cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
                tmpCell = cell

                return cell
                
            }
           else  if tipoSubProceso == .BanificacionPayPal && indexPath.row == selectedRow{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalBonificacionCell", for: indexPath) as! PayPalBonificacionTableViewCell
                cell.btnArrow.tag = indexPath.row
                cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
                tmpCell = cell
                
                return cell
                
            }
            else if tipoSubProceso == .BanificacionRecarga && indexPath.row == selectedRow{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaBonificacionCell", for: indexPath) as! RecargaBonificacionTableViewCell
                cell.btnArrow.tag = indexPath.row
                cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
                tmpCell = cell
                //                cell.lblTitulo.text = "PayPal"
                return cell
                
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
                if indexPath.row == 0{
                    cell.lblTitulo.text = "Bancaria"
                    cell.btnArrow.tag = indexPath.row
                    cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                }
                else if indexPath.row == 1{
                    cell.lblTitulo.text = "PayPal"
                    cell.btnArrow.tag = indexPath.row
                    cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                }
                else{
                    cell.lblTitulo.text = "Recarga telefónica"
                    cell.btnArrow.tag = indexPath.row
                    cell.btnArrow.addTarget(self, action: #selector(selectBonificacionTableViewCell(_:)), for: .touchUpInside)
                }
                
                return cell
            }
            
        }
    }
    
    @objc
    func selectBonificacionTableViewCell(_ sender: Any){
        
        let button = sender as! UIButton
        let row = button.tag
        
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
            let index = IndexPath(row: row, section: 0)
            
            if previousSelectedRow != -1{
                let item = IndexPath(row: previousSelectedRow, section: 0)
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
                
                let rsp = try decoder.decode(SimpleResponse.self, from: data)
                print("\(rsp.code)")
                
            }
            catch{
                print("JSON Error: \(error)")
            }
        }
        else if identifier == ID_RQT_TICKETS{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(HistoricoTicket.self, from: data)
                print("\(rsp.code)")
                tickets = rsp.tickets
                tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
                
            }
            catch{
                print("JSON Error: \(error)")
            }
        }
        else if identifier == ID_RQT_BONIFICACIONES{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(HistoricoBonificacion.self, from: data)
                print("\(rsp.code)")
                bonificaciones = rsp.historicoMediosBonificaciones
                tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
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
