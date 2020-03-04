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

class SolicitarBonificacionTableViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate {

    //MARK: - Propiedades
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblMensaje: UILabel!
    
    
    struct TableViewCellIdentifiers {
        static let bancoBonificacionCell = "BancoBonificacionCell"
        static let payPalBonificacionCell = "PayPalBonificacionCell"
        static let recargaBonificacionCell = "RecargaBonificacionCell"
    }
    
    let ID_RQT_BONIFICACION = "ID_RQT_BONIFICACION"
    let ID_RQT_CATALOGO = "ID_RQT_CATALOGO"
    var tipoRetiro: TipoRetiro = .Bancario
    var medios: MediosBonificacionRSP = MediosBonificacionRSP()
    var tmpCell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 10.0
        configureBarButtons()
        print("Tipo de retiro: \(tipoRetiro)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        catalogoMediosRequest()
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
                let resp = cell.isValid()
                if resp.valid{
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
                else{
                    self.tableView.endEditing(true)
                    present(resp.alert!, animated: true, completion: nil)
                }
            }
            
            
        }
        else if tipoRetiro == .PayPal{
            if let cell = tmpCell as? PayPalBonificacionTableViewCell{
                let resp = cell.isValid()
                if resp.valid{
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
                else{
                    self.tableView.endEditing(true)
                    present(resp.alert!, animated: true, completion: nil)
                }
            }
            
        }
        else if tipoRetiro == .Telefonica{
            if let cell = tmpCell as? RecargaBonificacionTableViewCell{
                let resp = cell.isValid()
                if resp.valid{
                    print("Guardando solicitud de Recarga")
                    
                    let item = Bonificacion()
                    //Quitar el signo de pesos
                    let cantidad = cell.txtCantidad.text!.replacingOccurrences(of: "$", with: "")
                    item.cantidadBonificacion = Double( cantidad )
                    
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
                else{
                    self.tableView.endEditing(true)
                    present(resp.alert!, animated: true, completion: nil)
                }
                
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
}

//MARK: - Extension
extension SolicitarBonificacionTableViewController: MediosBonificacionControllerDelegate{
    func addItemViewController(_ controller: MediosBonificacionDetailViewController, didFinishAddind item: String) {
        
        lblMensaje.text = item
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.topConstraint.constant = 50
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
        }, completion: { (true) in
            UIView.animate(withDuration: 2.0,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 5.0,
                           options: [.curveEaseIn],
                           animations: {
                            self.topConstraint.constant = 0
                            self.view.setNeedsLayout()
                            self.view.layoutIfNeeded()
            }, completion: nil)
        })
        
        self.navigationController?.popViewController(animated: true)
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
    func back(){
                self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func showHome(){
//        self.navigationController?.popToRootViewController(animated: true)
        
        let cancel =
        UIAlertAction(title: "Salir",
                      style: .default){action in
                        self.navigationController?.popToRootViewController(animated: true)
                      }
        
        let acept = prepareAceptAction()
        if handleOnExitViewControllerWith(cancelAction: cancel, and: acept){
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc
    func showView(){
//        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "BonificacionViewController")
//        self.navigationController!.pushViewController(destViewController, animated: true)
        
        let cancel =
        UIAlertAction(title: "Salir",
                      style: .default){action in
                        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "BonificacionViewController")
                        self.navigationController!.pushViewController(destViewController, animated: true)
                      }
        
        let acept = prepareAceptAction()
        if handleOnExitViewControllerWith(cancelAction: cancel, and: acept){
            let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "BonificacionViewController")
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    @objc
    func showNotif(){
//        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
//        self.navigationController!.pushViewController(destViewController, animated: true)
        
        let cancel =
        UIAlertAction(title: "Salir",
                      style: .default){action in
                        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
                        self.navigationController!.pushViewController(destViewController, animated: true)
                      }
        
        let acept = prepareAceptAction()
        if handleOnExitViewControllerWith(cancelAction: cancel, and: acept){
            let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    @objc
    func showMenu(){
//        present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
        
        let cancel =
        UIAlertAction(title: "Salir",
                      style: .default){action in
                        self.present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
                      }
        
        let acept = prepareAceptAction()
        if handleOnExitViewControllerWith(cancelAction: cancel, and: acept){
            self.present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
        }
    }
    
    func cleanTextFields(){
        if let cell = tmpCell as? BancoBonificacionTableViewCell{
            cell.clean()
        }
        if let cell = tmpCell as? RecargaBonificacionTableViewCell{
            cell.clean()
        }
        if let cell = tmpCell as? PayPalBonificacionTableViewCell{
            cell.clean()
        }
    }
    
    func handleOnExitViewControllerWith(cancelAction: UIAlertAction, and aceptAction: UIAlertAction) -> Bool{
            
        var noProcess = true
        var formIsEmpty = true
            
        if let cell = tmpCell as? BancoBonificacionTableViewCell{
            formIsEmpty = cell.formIsEmpty()
        }
        if let cell = tmpCell as? RecargaBonificacionTableViewCell{
            formIsEmpty = cell.formIsEmpty()
        }
        if let cell = tmpCell as? PayPalBonificacionTableViewCell{
            formIsEmpty = cell.formIsEmpty()
        }
            
        if !formIsEmpty{
            noProcess = false
            handleMessageOnExitViewController(message: "Aun no has solicitado tu retiro, ¿Aun asi quieres salir?", title: "Shing Shing", cancelAction: cancelAction, aceptAction: aceptAction)
        }
            
        return noProcess
    }
    
    func handleMessageOnExitViewController(message: String, title: String, cancelAction: UIAlertAction, aceptAction: UIAlertAction){
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(cancelAction)
        alert.addAction(aceptAction)
        present(alert, animated: true, completion: nil)
    }
    
    func prepareAceptAction() -> UIAlertAction{
        let acept =
        UIAlertAction(title: "Seguir aquí",
                      style: .default){action in
                        
                        var result: (valid: Bool, alert: UIAlertController?) = (false, nil)
                        
                        if let cell = self.tmpCell as? BancoBonificacionTableViewCell{
                            result = cell.isValid()
                        }
                        else if let cell = self.tmpCell as? PayPalBonificacionTableViewCell{
                            result = cell.isValid()
                            
                        }
                        else if let cell = self.tmpCell as? RecargaDetailTableViewCell{
                            result = cell.isValid()
                        }
                        
                        if !result.valid{
                            self.present(result.alert!, animated: true, completion: nil)
                        }
                        else{
                            self.guardarItem()
                            
                            print("Guardar o actualiza segun sea el caso")
                        }
        }
        
        return acept
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
                    cleanTextFields()
                    performSegue(withIdentifier: "ConformacionSegue", sender: self)
                }
                else if rsp.code == 202{
                    Model.totalBonificacion = rsp.bonificacion
                    let alert = Validations.show(message: "Fondos insuficientes", with: "Shing Shing")
                    cleanTextFields()
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    performSegue(withIdentifier: "ErrorSegue", sender: self)
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
                tableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
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
            title: "Shing Shing",
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
