//
//  DatosTicketViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/3/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class DatosTicketViewController: UIViewController {
    
    //MARK: - Propiedades
    @IBOutlet weak var tableView: UITableView!
    
    var isMenuVisible = false
    var datosTicket = OCRResponse()
    var total: Double = 0.0
    
    let ID_RQT_GUARDAR = "ID_RQT_GUARDAR"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        configureBarButtons()
        calcularTotal()
    }
    
    //MARK: - Actions
    
    //MARK: - Helper methods
    func calcularTotal(){

            for p in datosTicket.productos {
                total = total + p.cantidadBonificacion!
            }
    }
    
    func configureBarButtons(){
        let img = UIImage(named: "money-grey")
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 8, y: 6, width: 22, height: 22)
        
        let lblBonificacion = UILabel()
        lblBonificacion.font = UIFont(name: "Nunito SemiBold", size: 17)
        lblBonificacion.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        lblBonificacion.text = Validations.formatWith(Model.totalBonificacion)
        
        lblBonificacion.sizeToFit()
        let frame = lblBonificacion.frame
        lblBonificacion.frame = CGRect(x: 31, y: 6, width: frame.width, height: frame.height)
        
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
        let button = UIButton(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height))
        button.addTarget(self, action: #selector(showView), for: .touchUpInside)
        view.addSubview(button)
        
        self.navigationItem.titleView = view
        
        let home = UIBarButtonItem(
            image: UIImage(named: "logo-menu"),
            style: .plain,
            target: self,
            action: #selector(showHome))
        home.tintColor = .black
        
        let notif = UIBarButtonItem(
            image: UIImage(named: "notification-grey"),
            style: .plain,
            target: self,
            action: #selector(showNotif))
        notif.tintColor = .black
        
        let user = UIBarButtonItem(
            image: UIImage(named: "menu-grey"),
            style: .plain,
            target: self,
            action: #selector(showMenu))
        user.tintColor = .black
        navigationItem.rightBarButtonItems = [user, notif]
        navigationItem.leftBarButtonItems = [home]
    }
    
    @objc
    func showHome(){
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func showView(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "BonificacionViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
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
    
    @objc
    func enviarTicket(){
//        performSegue(withIdentifier: "EnviarTicketSegue", sender: self)
        registrarTicketRequest()
    }
    
    func registrarTicketRequest(){
        do{
            let encoder = JSONEncoder()
            let user = Usuario()
            user.idUsuario = Model.user?.idUsuario
            
            //Crear informacion de ticket
            let ticket = Ticket()
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let result = formatter.string(from: date)
            
            ticket.nombreTienda = datosTicket.tienda
            ticket.sucursal = ""
            ticket.fecha = result
//            ticket.hora = "2019-06-24T13:18:09"
            ticket.subtotal = total
            ticket.iva = 0.0
            ticket.total = total
            ticket.ticket_tienda = datosTicket.tienda
            ticket.ticket_subTienda = datosTicket.subTienda
            ticket.ticket_fecha = datosTicket.fecha
            ticket.ticket_hora = datosTicket.hora
            ticket.ticket_transaccion = datosTicket.transaccion
            
            //Productos encontrados en el ticket
//            let p = Producto()
//            p.idProducto = 1
//
//            var productos = [Producto]()
//            productos.append(p)
            
            ticket.productos = datosTicket.productos
            user.tickets = [ticket]

//            performSegue(withIdentifier: "EnviarTicketSegue", sender: self)
            
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.registrarTicket, with: json, and: ID_RQT_GUARDAR)
        }
        catch{
            
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnviarTicketSegue"{
            let vc = segue.destination as! ProcesaTicketViewController
            vc.total = total
            vc.delegate = self
        }
        
        if segue.identifier == "TicketDuplicadoSegue"{
            let vc = segue.destination as! TicketDuplicadoViewController
            vc.delegate = self
        }
    }

}

//MARK: - Extensions
extension DatosTicketViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 2{
//            return "Productos"
//        }
//        return ""
//    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 50
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2{
            let header = Bundle.main.loadNibNamed("HeaderProductosTicket", owner: nil, options: nil)!.first as! UIView
            
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 80
        case 2:
            return 70
        case 3:
            return 160
        default:
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return datosTicket.productos.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MensajeCell", for: indexPath)
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTicketTableViewCell
            
            return cell
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! TotalTicketTableViewCell
            cell.lblTotal.text = Validations.formatWith(total)
            cell.btnEnviar.addTarget(self, action: #selector(enviarTicket), for: .touchUpInside)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath) as! ProductoTicketTableViewCell
            
            let item = datosTicket.productos[indexPath.row]
            
            cell.lblNombre.text = item.nombreProducto
            cell.lblPresentacion.text = item.presentacion
            cell.lblCantidad.text = "Cant: 1"
            cell.lblCodigo.text = item.codigoBarras
            cell.lblBonificacion.text = Validations.formatWith(item.cantidadBonificacion)
            
            
            return cell
        }
    }
}

//MARK: - RESTActionDelegate
extension DatosTicketViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            let decoder = JSONDecoder()
            
            let rsp = try decoder.decode(SimpleResponse.self, from: data)
            if let code = rsp.code{
                if code == 200{
                    print("Ticker registrado de forma correcta")
                    performSegue(withIdentifier: "EnviarTicketSegue", sender: self)
                }
                else{
                    print("Problemas el registrar ticket")
                    performSegue(withIdentifier: "TicketDuplicadoSegue", sender: self)
                }
            }
        }
        catch{
            
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

extension DatosTicketViewController: ProcesaTicketViewControllerDelegate{
    func didCompleted(_ controller: ProcesaTicketViewController) {
        dismiss(animated: true, completion: nil)
        
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is CustomCameraViewController {
                _ = self.navigationController?.popToViewController(vc as! CustomCameraViewController, animated: true)
            }
        }
    }
}

extension DatosTicketViewController: TicketDuplicadoViewControllerDelegate{
    func didCompleted(_ controller: TicketDuplicadoViewController) {
        dismiss(animated: true, completion: nil)
        
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is CustomCameraViewController {
                _ = self.navigationController?.popToViewController(vc as! CustomCameraViewController, animated: true)
            }
        }
        
//        self.navigationController?.popViewController(animated: true)
    }
}
