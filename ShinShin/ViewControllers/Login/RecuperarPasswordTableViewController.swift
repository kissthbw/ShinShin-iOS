//
//  RecuperarPasswordTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/1/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class RecuperarPasswordTableViewController: UITableViewController {

    @IBOutlet weak var viewCorreo: UIView!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var btnEnviar: UIButton!
    
    let ID_RQT_PASSWORD = "ID_RQT_PASSWORD"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        txtCorreo.delegate = self
        btnEnviar.layer.cornerRadius = 10.0
        viewCorreo.layer.cornerRadius = 10.0
    }
    
    //MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func enviarAction(_ sender: Any) {
        
        if Validations.isEmpty(value: txtCorreo.text!){
            txtCorreo.showError(true, superView: true)
            let alert = Validations.show(message: "Ingresa tu correo electrónico", with: "ShingShing")
            present(alert, animated: true, completion: nil)
            return
        }
        
        recuperarPasswordRequest()
    }
    
    //MARK: - Helper methods
    func recuperarPasswordRequest(){
        do{
            RESTHandler.delegate = self
            let item = Usuario()
            item.correoElectronico = txtCorreo.text!
            
            let encoder = JSONEncoder()
            let json = try encoder.encode(item)
            
            RESTHandler.postOperationTo(RESTHandler.restaurarPassword, with: json, and: ID_RQT_PASSWORD)
        }
        catch{
            print("Error al enviar sugerencia")
        }
    }
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmacionRecuperarSegue"{
//            let vc = segue.destination as! 
        }
    }
}

extension RecuperarPasswordTableViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.showError(false, superView: true)
    }
}

//MARK: - RESTActionDelegate
extension RecuperarPasswordTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        do{
            let decoder = JSONDecoder()
            if identifier == ID_RQT_PASSWORD{
                do{
                    let decoder = JSONDecoder()
                    
                    let rsp = try decoder.decode(InformacionUsuario.self, from: data)
                    if rsp.code == 200{
                        //Enviar mensaje de exito, limpiar textfield y ocultar teclado
//                        let alert = Validations.show(message: "Recibiras un correo en la cuenta que proporcionaste", with: "ShingShing")
                        self.txtCorreo.text = ""
                        self.tableView.endEditing(true)
                        performSegue(withIdentifier: "ConfirmacionRecuperarSegue", sender: self)
                        
//                        present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert = Validations.show(message: "Ocurrió un error, intenta mas tarde", with: "ShingShing")

                        self.tableView.endEditing(true)
                        present(alert, animated: true, completion: nil)
                    }
                    
                }
                catch{
                    print("JSON Error: \(error)")
                }
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
