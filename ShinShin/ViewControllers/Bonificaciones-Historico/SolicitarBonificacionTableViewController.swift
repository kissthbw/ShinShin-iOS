//
//  SolicitarBonificacionTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 8/22/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

enum TipoRetiro: Int{
    case Bancario = 1
    case PayPal = 2
    case Telefonica = 3
}

class SolicitarBonificacionTableViewController: UITableViewController {

    //MARK: - Propiedades
    struct TableViewCellIdentifiers {
        static let bancoBonificacionCell = "BancoBonificacionCell"
        static let payPalBonificacionCell = "PayPalBonificacionCell"
        static let recargaBonificacionCell = "RecargaBonificacionCell"
    }
    
    let ID_RQT_BONIFICACION = "ID_RQT_BONIFICACION"
    var tipoRetiro: TipoRetiro = .Bancario
    var medios: MediosBonificacionRSP = MediosBonificacionRSP()
    var tmpCell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtons()
        print("Tipo de retiro: \(tipoRetiro)")
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
//    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConformacionSegue"{
            let vc = segue.destination as! ConfirmacionBonificacionViewController
            vc.tipoRetiro = tipoRetiro
        }
        else{
            let vc = segue.destination as! MediosBonificacionDetailViewController
            vc.sectionSelected = 1
//            vc.delegate = self
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tipoRetiro == .Bancario{
            return configureCell(for: indexPath)
        }
        else if tipoRetiro == .PayPal{
            return configureCell(for: indexPath)
        }
        else{ //if tipoRetiro == .Telefonica{
            return configureCell(for: indexPath)
        }

    }

}

extension SolicitarBonificacionTableViewController{
    
    //MARK: - Helper methods
    func configureCell(for indexPath: IndexPath) -> UITableViewCell{
        
        if tipoRetiro == .Bancario{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.bancoBonificacionCell, for: indexPath) as! BancoBonificacionTableViewCell
            
            let cuentas = medios.mediosBonificacion?[0].list
            
            cell.cuentas = cuentas
            
            cell.btnAgregar.addTarget(self, action: #selector(mostrarCuentas), for: .touchUpInside)
            cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            cell.btnBack.addTarget(self, action: #selector(back), for: .touchUpInside)
            tmpCell = cell
            return cell
        }
        else if tipoRetiro == .PayPal{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.payPalBonificacionCell, for: indexPath) as! PayPalBonificacionTableViewCell
            
            let cuentas = medios.mediosBonificacion?[1].list
            
            cell.cuentas = cuentas
            cell.btnAgregar.addTarget(self, action: #selector(mostrarCuentas), for: .touchUpInside)
            cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            cell.btnBack.addTarget(self, action: #selector(back), for: .touchUpInside)
            tmpCell = cell
            return cell
        }
        else{ //if tipoRetiro == .Telefonica{
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.recargaBonificacionCell, for: indexPath) as! RecargaBonificacionTableViewCell
            let cuentas = medios.mediosBonificacion?[2].list
            
            cell.cuentas = cuentas
            cell.btnAgregar.addTarget(self, action: #selector(mostrarCuentas), for: .touchUpInside)
            cell.btnSolicitar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            cell.btnBack.addTarget(self, action: #selector(back), for: .touchUpInside)
            tmpCell = cell
            return cell
        }
    }
    
    @objc func mostrarCuentas(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MediosBonificacionDetailViewController") as! MediosBonificacionDetailViewController
        vc.delegate = self
        vc.sectionSelected = tipoRetiro.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func guardarItem(){
        if tipoRetiro == .Bancario{
            
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
        else if tipoRetiro == .PayPal{
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
        else if tipoRetiro == .Telefonica{
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
}

//MARK: - Extension
extension SolicitarBonificacionTableViewController: MediosBonificacionControllerDelegate{
    func addItemViewController(_ controller: MediosBonificacionDetailViewController, didFinishAddind item: String) {
        print("Cuenta agregada: \(item)")
    }
}

extension SolicitarBonificacionTableViewController{
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
    func back(){
                self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func showHome(){
        self.navigationController?.popToRootViewController(animated: true)
//        self.navigationController?.popViewController(animated: true)
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
}

extension SolicitarBonificacionTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        if identifier == ID_RQT_BONIFICACION{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(InformacionUsuario.self, from: data)
                if rsp.code == 200{
                    print("Solicitud guardada con exito")
                    Model.totalBonificacion = rsp.bonificacion

                    performSegue(withIdentifier: "ConformacionSegue", sender: self)
                }
                else{
                    performSegue(withIdentifier: "ErrorSegue", sender: self)
                }
                
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
