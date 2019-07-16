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
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
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
            ticket.nombreTienda = "OXXO"
            ticket.sucursal = "Periferico"
            ticket.fecha = "2019-06-24"
//            ticket.hora = "2019-06-24T13:18:09"
            ticket.subtotal = 91.56
            ticket.iva = 17.44
            ticket.total = 109
            
            //Productos encontrados en el ticket
            let p = Producto()
            p.idProducto = 1
            
            var productos = [Producto]()
            productos.append(p)
            
            ticket.productos = productos
            user.tickets = [ticket]

//            performSegue(withIdentifier: "EnviarTicketSegue", sender: self)
            
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.registrarTicket, with: json, and: ID_RQT_GUARDAR)
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
            return 160
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
