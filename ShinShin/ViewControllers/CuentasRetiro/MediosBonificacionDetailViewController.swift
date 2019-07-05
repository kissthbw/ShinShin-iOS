//
//  MediosBonificacionDetailViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

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
    
    var tmpCell: UITableViewCell?
    var tipoCuenta: TipoCuenta = .Bancaria
    var sectionSelected = -1
    var item: MediosBonificacion?
    weak var delegate: MediosBonificacionControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Helper Methods
    @objc func guardarItem(){
        //guardarMedioBonificacionUsuario
        if tipoCuenta == .Bancaria{
            if let cell = tmpCell as? BancoDetailTableViewCell{
                let item = MediosBonificacion()
                let cat = CatalogoMediosBonificacion()
                cat.idCatalogoMedioBonificacion = 1
                let user = Usuario()
                user.idUsuario = Model.user?.idUsuario
                
                item.usuario = user
                item.catalogoMediosBonificacion = cat
                item.aliasMedioBonificacion = cell.txtNombre.text
                item.cuentaMedioBonificacion = cell.txtTarjeta.text
                item.vigenciaMedioBonificacion = "09/21"
                guardarMedioBonificacionRequest(with: item)
            }
        }
        else if tipoCuenta == .PayPal{
            if let cell = tmpCell as? PayPalDetailTableViewCell{
                let item = MediosBonificacion()
                let cat = CatalogoMediosBonificacion()
                cat.idCatalogoMedioBonificacion = 2
                let user = Usuario()
                user.idUsuario = Model.user?.idUsuario
                
                item.usuario = user
                item.catalogoMediosBonificacion = cat
                item.aliasMedioBonificacion = cell.txtNombre.text
                item.idCuentaMedioBonificacion = cell.txtId.text
                item.cuentaMedioBonificacion = cell.txtEmail.text
                guardarMedioBonificacionRequest(with: item)
            }
        }
        else if tipoCuenta == .Recarga{
            if let cell = tmpCell as? RecargaDetailTableViewCell{
                let item = MediosBonificacion()
                let cat = CatalogoMediosBonificacion()
                cat.idCatalogoMedioBonificacion = 3
                let user = Usuario()
                user.idUsuario = Model.user?.idUsuario
                
                item.usuario = user
                item.catalogoMediosBonificacion = cat
                item.aliasMedioBonificacion = cell.txtNombre.text
                item.cuentaMedioBonificacion = cell.txtNumero.text
                item.companiaMedioBonificacion = cell.txtCompania.text
                guardarMedioBonificacionRequest(with: item)
            }
        }
    }
    
    func configureBancoDetailCell(atIndexPath indexPath: IndexPath, withItem item: MediosBonificacion?) -> UITableViewCell{
        tipoCuenta = .Bancaria
        let cell = tableView.dequeueReusableCell(withIdentifier: "BancoDetailCell", for: indexPath) as! BancoDetailTableViewCell
        
        if let itemToEdit = item{
            
            //            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            cell.txtNombre.text = itemToEdit.aliasMedioBonificacion
            cell.txtTarjeta.text = itemToEdit.cuentaMedioBonificacion
            
        }
        else{
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            tmpCell = cell
        }
        
        return cell
    }
    
    func configurePayPalDetailCell(atIndexPath indexPath: IndexPath, withItem item: MediosBonificacion?) -> UITableViewCell{
        tipoCuenta = .PayPal
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalDetailCell", for: indexPath) as! PayPalDetailTableViewCell
        
        cell.txtNombre.delegate = self
        cell.txtId.delegate = self
        cell.txtEmail.delegate = self
        
        if let itemToEdit = item{
            cell.txtNombre.text = itemToEdit.aliasMedioBonificacion
            cell.txtId.text = itemToEdit.idCuentaMedioBonificacion
            cell.txtEmail.text = itemToEdit.cuentaMedioBonificacion
            
            //            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
        }
        else{
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            tmpCell = cell
        }
        
        
        return cell
    }
    
    func configureRecargaDetailCell(atIndexPath indexPath: IndexPath, withItem item: MediosBonificacion?) -> UITableViewCell{
        tipoCuenta = .Recarga
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaDetailCell", for: indexPath) as! RecargaDetailTableViewCell
        
        cell.txtNombre.delegate = self
        cell.txtNumero.delegate = self
        cell.txtCompania.delegate = self
        
        if let itemToEdit = item{
            cell.txtNombre.text = itemToEdit.aliasMedioBonificacion
            cell.txtNumero.text = itemToEdit.cuentaMedioBonificacion
            cell.txtCompania.text = itemToEdit.companiaMedioBonificacion
            //            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
        }
        else{
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            tmpCell = cell
        }
        
        return cell
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
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CompaniaSegue"{
            let vc = segue.destination as! CompaniaTelefonicaTableViewController
            vc.delegate = self
        }
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
            
                let rsp = try decoder.decode(SimpleResponse.self, from: data)
            delegate?.addItemViewController(self, didFinishAddind: "Tarjeta agregada")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
