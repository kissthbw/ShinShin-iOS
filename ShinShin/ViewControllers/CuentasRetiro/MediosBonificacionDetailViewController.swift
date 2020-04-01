//
//  MediosBonificacionDetailViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

protocol MediosBonificacionControllerDelegate: class{
//    func addItemViewController(_ controller: ItemDetailViewController,
//                               didFinishAdding item: ChecklistItem)
//    func addItemViewController(_ controller: ItemDetailViewController,
//                               didFinichEditing item: ChecklistItem)
    func addItemViewController(_ controller: MediosBonificacionDetailViewController, didFinishAddind item: String)
}

class MediosBonificacionDetailViewController: UITableViewController {

    //MARK: - Propiedades
    enum TipoCuenta{
        case Bancaria
        case PayPal
        case Recarga
    }
    
    let ID_RQT_GUARDAR = "ID_RQT_GUARDAR"
    let ID_RQT_ELIMINAR = "ID_RQT_ELIMINAR"
    let ID_RQT_ACTUALIZAR = "ID_RQT_ACTUALIZAR"
    
    var tmpCell: UITableViewCell?
    var tipoCuenta: TipoCuenta = .Bancaria
    var sectionSelected = -1
    var item: MediosBonificacion?
    var idMedio = -1
    var mensaje = ""
    
    weak var delegate: MediosBonificacionControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        configureBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    }
    
    @IBAction func back(_ sender: Any) {
        
        let cancel =
        UIAlertAction(title: "No",
                      style: .default){action in
                        self.navigationController?.popViewController(animated: true)
                      }
        
        let acept = prepareAceptAction()
        
        if handleOnExitViewControllerWith(cancelAction: cancel, and: acept){
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    //MARK: - Helper Methods
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
            action: nil)
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
    func showNotif(){
        
        let cancel =
        UIAlertAction(title: "No",
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
    func showView(){
        
        let cancel =
        UIAlertAction(title: "No",
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
    func showMenu(){
        let cancel =
        UIAlertAction(title: "No",
                      style: .default){action in
                        self.present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
                      }
        
        let acept = prepareAceptAction()
        
        if handleOnExitViewControllerWith(cancelAction: cancel, and: acept){
            present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
        }
    }
    
    //Maneja la salida de la pantalla, veirifcando si existen cambios que guardar
    func prepareAceptAction() -> UIAlertAction{
        let acept =
        UIAlertAction(title: "Si",
                      style: .default){action in
                        
                        var result: (valid: Bool, alert: UIAlertController?) = (false, nil)
                        
                        if let cell = self.tmpCell as? BancoDetailTableViewCell{
                            result = cell.isValid()
                        }
                        else if let cell = self.tmpCell as? PayPalDetailTableViewCell{
                            result = cell.isValid()
                            
                        }
                        else if let cell = self.tmpCell as? RecargaDetailTableViewCell{
                            result = cell.isValid()
                        }
                        
                        if !result.valid{
                            self.present(result.alert!, animated: true, completion: nil)
                        }
                        else{
                            if self.item != nil{
                                self.actualizarItem()
                            }
                            else{
                                self.guardarItem()
                            }
                            
                            print("Guardar o actualiza segun sea el caso")
                        }
        }
        
        return acept
    }
    
    func handleOnExitViewControllerWith(cancelAction: UIAlertAction, and aceptAction: UIAlertAction) -> Bool{
        
        var noProcess = true
        var formUpdated = false
        var formIsEmpty = true
        
        if item != nil{
            //Validar si han actualizado campo
            if let cell = tmpCell as? BancoDetailTableViewCell{
               formUpdated = cell.formHasBeenUpdated()
            }
            if let cell = tmpCell as? RecargaDetailTableViewCell{
                formUpdated = cell.formHasBeenUpdated()
            }
            if let cell = tmpCell as? PayPalDetailTableViewCell{
                formUpdated = cell.formHasBeenUpdated()
            }
            
            if formUpdated{
                noProcess = false
                handleMessageOnExitViewController(message: "¿Quieres guardar tus cambios antes de salir?", title: "Shing Shing", cancelAction: cancelAction, aceptAction: aceptAction)

            }
        }
        else{
            if let cell = tmpCell as? BancoDetailTableViewCell{
               formIsEmpty = cell.formIsEmpty()
            }
            if let cell = tmpCell as? RecargaDetailTableViewCell{
                formIsEmpty = cell.formIsEmpty()
            }
            if let cell = tmpCell as? PayPalDetailTableViewCell{
                formIsEmpty = cell.formIsEmpty()
            }
            
            if !formIsEmpty{
                noProcess = false
                handleMessageOnExitViewController(message: "¿Quieres guardar tus cambios antes de salir?", title: "Shing Shing", cancelAction: cancelAction, aceptAction: aceptAction)
            }
        }
        
//        if let cell = tmpCell as? BancoDetailTableViewCell{
//
//            if item != nil{
//                //Validar si han actualizado campo
//                if cell.formHasBeenUpdated(){
//                    noProcess = false
//                    handleMessageOnExitViewController(message: "¿Quieres guardar tus cambios antes de salir?", title: "Shing Shing", cancelAction: cancelAction, aceptAction: aceptAction)
//
//                }
//            }
//            else{
//                if !cell.formIsEmpty(){
//                    noProcess = false
//                    handleMessageOnExitViewController(message: "¿Quieres guardar tus cambios antes de salir?", title: "Shing Shing", cancelAction: cancelAction, aceptAction: aceptAction)
//                }
//            }
//        }
//        
        
        return noProcess
    }
    
    @objc func actualizarItem(){
        if tipoCuenta == .Bancaria{
            if let cell = tmpCell as? BancoDetailTableViewCell{
                let resp = cell.isValid()
                if resp.valid{
                    let item = MediosBonificacion()
                    item.idMediosBonificacion = idMedio
                    let cat = CatalogoMediosBonificacion()
                    cat.idCatalogoMedioBonificacion = 1
                    let user = Usuario()
                    user.idUsuario = Model.user?.idUsuario
                    
                    item.usuario = user
                    item.catalogoMediosBonificacion = cat
                    item.aliasMedioBonificacion = cell.txtAlias.text
                    item.cuentaMedioBonificacion = cell.txtTarjeta.text
                    item.idTipo = cell.idTipoBancaria
                    item.banco = cell.txtBanco.text
                    
                    actualizarMedioBonificacionRequest(with: item)
                }
                else{
                    self.tableView.endEditing(true)
                    present(resp.alert!, animated: true, completion: nil)
                }
            }
        }
        else if tipoCuenta == .PayPal{
            if let cell = tmpCell as? PayPalDetailTableViewCell{
                let resp = cell.isValid()
                if resp.valid{
                    let item = MediosBonificacion()
                    item.idMediosBonificacion = idMedio
                    let cat = CatalogoMediosBonificacion()
                    cat.idCatalogoMedioBonificacion = 2
                    let user = Usuario()
                    user.idUsuario = Model.user?.idUsuario
                    
                    item.usuario = user
                    item.catalogoMediosBonificacion = cat
                    item.idCuentaMedioBonificacion = cell.txtId.text
                    item.cuentaMedioBonificacion = cell.txtEmail.text
                    item.aliasMedioBonificacion = cell.txtAlias.text
                    actualizarMedioBonificacionRequest(with: item)
                }
                else{
                    present(resp.alert!, animated: true, completion: nil)
                }
            }
        }
        else if tipoCuenta == .Recarga{
            if let cell = tmpCell as? RecargaDetailTableViewCell{
                let resp = cell.isValid()
                if resp.valid{
                    let item = MediosBonificacion()
                    item.idMediosBonificacion = idMedio
                    let cat = CatalogoMediosBonificacion()
                    cat.idCatalogoMedioBonificacion = 3
                    let user = Usuario()
                    user.idUsuario = Model.user?.idUsuario
                    
                    item.usuario = user
                    item.catalogoMediosBonificacion = cat
                    item.cuentaMedioBonificacion = cell.txtNumero.text
                    item.companiaMedioBonificacion = cell.txtCompania.text
                    item.aliasMedioBonificacion = cell.txtAlias.text
                    actualizarMedioBonificacionRequest(with: item)
                }
                else{
                    present(resp.alert!, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func eliminarItem(){
        let item = MediosBonificacion()
        item.idMediosBonificacion = idMedio
        
        eliminarMedioBonificacionRequest(with: item)
    }
    
    @objc func guardarItem(){
        //guardarMedioBonificacionUsuario
        if tipoCuenta == .Bancaria{
            if let cell = tmpCell as? BancoDetailTableViewCell{
                let resp = cell.isValid()
                if resp.valid{
                    let item = MediosBonificacion()
                    let cat = CatalogoMediosBonificacion()
                    cat.idCatalogoMedioBonificacion = 1
                    let user = Usuario()
                    user.idUsuario = Model.user?.idUsuario
                    
                    item.usuario = user
                    item.catalogoMediosBonificacion = cat
                    item.aliasMedioBonificacion = cell.txtAlias.text
                    item.cuentaMedioBonificacion = cell.txtTarjeta.text
                    item.idTipo = cell.idTipoBancaria
                    item.banco = cell.txtBanco.text
                    
                    guardarMedioBonificacionRequest(with: item)
                }
                else{
                    self.tableView.endEditing(true)
                    present(resp.alert!, animated: true, completion: nil)
                }
            }
        }
        else if tipoCuenta == .PayPal{
            if let cell = tmpCell as? PayPalDetailTableViewCell{
                let resp = cell.isValid()
                if resp.valid{
                    let item = MediosBonificacion()
                    let cat = CatalogoMediosBonificacion()
                    cat.idCatalogoMedioBonificacion = 2
                    let user = Usuario()
                    user.idUsuario = Model.user?.idUsuario
                    
                    item.usuario = user
                    item.catalogoMediosBonificacion = cat
                    item.idCuentaMedioBonificacion = cell.txtId.text
                    item.cuentaMedioBonificacion = cell.txtEmail.text
                    item.aliasMedioBonificacion = cell.txtAlias.text
                    guardarMedioBonificacionRequest(with: item)
                }
                else{
                    self.tableView.endEditing(true)
                    present(resp.alert!, animated: true, completion: nil)
                }
            }
        }
        else if tipoCuenta == .Recarga{
            if let cell = tmpCell as? RecargaDetailTableViewCell{
                
                let resp = cell.isValid()
                if resp.valid{
                    let item = MediosBonificacion()
                    let cat = CatalogoMediosBonificacion()
                    cat.idCatalogoMedioBonificacion = 3
                    let user = Usuario()
                    user.idUsuario = Model.user?.idUsuario
                    
                    item.usuario = user
                    item.catalogoMediosBonificacion = cat
                    item.cuentaMedioBonificacion = cell.txtNumero.text
                    item.companiaMedioBonificacion = cell.txtCompania.text
                    item.aliasMedioBonificacion = cell.txtAlias.text
                    guardarMedioBonificacionRequest(with: item)
                }
                else{
                    self.tableView.endEditing(true)
                    present(resp.alert!, animated: true, completion: nil)
                }
            }
        }
    }
    
    func configureBancoDetailCell(atIndexPath indexPath: IndexPath, withItem item: MediosBonificacion?) -> UITableViewCell{
        tipoCuenta = .Bancaria
        let cell = tableView.dequeueReusableCell(withIdentifier: "BancoDetailCell", for: indexPath) as! BancoDetailTableViewCell
        
        if let itemToEdit = item{
            idMedio = itemToEdit.idMediosBonificacion!
            mensaje = "Aqui no pasó nada, cuenta eliminada"
            cell.setItem(item: itemToEdit)
            if let tipo = itemToEdit.idTipo{
                cell.idTipo = tipo
                cell.idTipoBancaria = tipo
            }
            
            
            cell.lblTitulo.text = itemToEdit.aliasMedioBonificacion
            cell.txtTarjeta.text = itemToEdit.cuentaMedioBonificacion
            cell.txtBanco.text = itemToEdit.banco
            cell.txtAlias.text = itemToEdit.aliasMedioBonificacion
            cell.btnEliminar.isHidden = false
            cell.btnEliminar.addTarget(self, action: #selector(eliminarItem), for: .touchUpInside)
            cell.btnGuardar.addTarget(self, action: #selector(actualizarItem), for: .touchUpInside)
            tmpCell = cell
        }
        else{
            cell.btnEliminar.isHidden = true
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            tmpCell = cell
        }
        
        return cell
    }
    
    func configurePayPalDetailCell(atIndexPath indexPath: IndexPath, withItem item: MediosBonificacion?) -> UITableViewCell{
        tipoCuenta = .PayPal
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalDetailCell", for: indexPath) as! PayPalDetailTableViewCell
        
        if let itemToEdit = item{
            idMedio = itemToEdit.idMediosBonificacion!
            mensaje = "Aqui no pasó nada, cuenta eliminada"
            cell.setItem(item: itemToEdit)
            cell.lblTitulo.text = itemToEdit.aliasMedioBonificacion
            cell.txtId.text = itemToEdit.idCuentaMedioBonificacion
            cell.txtEmail.text = itemToEdit.cuentaMedioBonificacion
            cell.txtAlias.text = itemToEdit.aliasMedioBonificacion
            cell.btnEliminar.isHidden = false
            cell.btnEliminar.addTarget(self, action: #selector(eliminarItem), for: .touchUpInside)
            cell.btnGuardar.addTarget(self, action: #selector(actualizarItem), for: .touchUpInside)
            tmpCell = cell
        }
        else{
            cell.btnEliminar.isHidden = true
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            tmpCell = cell
        }
        
        
        return cell
    }
    
    func configureRecargaDetailCell(atIndexPath indexPath: IndexPath, withItem item: MediosBonificacion?) -> UITableViewCell{
        tipoCuenta = .Recarga
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaDetailCell", for: indexPath) as! RecargaDetailTableViewCell
        
        if let itemToEdit = item{
            idMedio = itemToEdit.idMediosBonificacion!
            mensaje = "Aqui no pasó nada, número eliminado"
            cell.setItem(item: itemToEdit)
            cell.lblTitulo.text = itemToEdit.aliasMedioBonificacion
            cell.txtNumero.text = itemToEdit.cuentaMedioBonificacion
            cell.txtCompania.text = itemToEdit.companiaMedioBonificacion
            cell.btnEliminar.isHidden = false
            cell.txtAlias.text = itemToEdit.aliasMedioBonificacion
            cell.btnEliminar.addTarget(self, action: #selector(eliminarItem), for: .touchUpInside)
            cell.btnGuardar.addTarget(self, action: #selector(actualizarItem), for: .touchUpInside)
            tmpCell = cell
        }
        else{
            cell.btnEliminar.isHidden = true
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            tmpCell = cell
        }
        
        return cell
    }
    
    func eliminarMedioBonificacionRequest(with item: MediosBonificacion){
        do{
            let encoder = JSONEncoder()
            
            let json = try encoder.encode(item)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.eliminarMedioBonificacionUsuario, with: json, and: ID_RQT_ELIMINAR)
        }
        catch{
            
        }
    }
    
    func actualizarMedioBonificacionRequest(with item: MediosBonificacion){
        do{
            let encoder = JSONEncoder()
            
            let json = try encoder.encode(item)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.actualizarMedioBonificacionUsuario, with: json, and: ID_RQT_ACTUALIZAR)
        }
        catch{
            
        }
    }
    
    func guardarMedioBonificacionRequest(with item: MediosBonificacion){
        do{
            let encoder = JSONEncoder()
            
            let json = try encoder.encode(item)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.guardarMedioBonificacionUsuario, with: json, and: ID_RQT_GUARDAR)
        }
        catch{
            
        }
    }
    
    //MARK: - Table view delegate
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//        print("scroll")
//    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 850
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sectionSelected == 1{
            return configureBancoDetailCell(atIndexPath: indexPath, withItem: item)
        }
        else if sectionSelected == 2{
            
            return configurePayPalDetailCell(atIndexPath: indexPath, withItem: item)
        }
        else{
            return configureRecargaDetailCell(atIndexPath: indexPath, withItem: item)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CompaniaSegue"{
            let vc = segue.destination as! CompaniaTelefonicaTableViewController
            vc.delegate = self
        }
        
        if segue.identifier == "CardScanSegue"{
            let vc = segue.destination as! CardScannerViewController
            vc.delegate = self
        }
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
}

//MARK: - Extensions
extension MediosBonificacionDetailViewController: CompaniaTelefonicaTableViewControllerDelegate{
    
    func selectItemViewController(_ controller: CompaniaTelefonicaTableViewController, didFinishAddind item: String) {
        
        if let cell = tmpCell as? RecargaDetailTableViewCell{
            cell.txtCompania.text = item
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}

//MARK: - RESTActionDelegate
extension MediosBonificacionDetailViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            let decoder = JSONDecoder()
           
            if identifier == ID_RQT_GUARDAR{
                
                var mensaje = ""
                if tipoCuenta == .PayPal{
                    mensaje = "Cuenta agregada"
                }
                else if tipoCuenta == .Bancaria{
                    mensaje = "Tarjeta agregada"
                }
                else if tipoCuenta == .Recarga{
                    mensaje = "Numero agregado"
                }
                print( "Tipo: \(tipoCuenta)" )
                
                let rsp = try decoder.decode(SimpleResponse.self, from: data)
                delegate?.addItemViewController(self, didFinishAddind: mensaje)
            }
            
            if identifier == ID_RQT_ELIMINAR{
                let rsp = try decoder.decode(SimpleResponse.self, from: data)
                delegate?.addItemViewController(self, didFinishAddind: mensaje)
            }
            
            if identifier == ID_RQT_ACTUALIZAR{
                let rsp = try decoder.decode(SimpleResponse.self, from: data)
                delegate?.addItemViewController(self, didFinishAddind: "Cambios guardados")
            }
        }
        catch{
            print("JSON Error: \(error)")
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

extension MediosBonificacionDetailViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.showError(false, superView: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension MediosBonificacionDetailViewController: CardScannerViewControllerDelegate{
    func cardScanViewController(_ controller: CardScannerViewController, didFinish cardNumber: String) {
        print("Numero de tarjeta: \(cardNumber)")
        if let cell = tmpCell as? BancoDetailTableViewCell{
            var tmp = cardNumber.separate(every: 4, with: " ")
            
            
            cell.txtTarjeta.text = tmp
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}
