//
//  UsuarioViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 4/6/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class UsuarioViewController: UITableViewController {


    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfPassword: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtMes: UITextField!
    @IBOutlet weak var txtDia: UITextField!
    @IBOutlet weak var txtAnio: UITextField!
    @IBOutlet weak var txtSexo: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var switchAceptar: UISwitch!
    
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var btnActivar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        let textfields = [txtNombre, txtCorreo, txtPassword, txtConfPassword,
        txtTelefono, txtMes, txtDia, txtAnio,
        txtSexo, txtCP, txtId, txtCodigo]

        initUIElements(textfields)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }


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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UI Actions
    @IBAction func registerAction(_ sender: Any){
        
        //Validar datos capturados
        
        //Enviar peticion a back
        //La respuesta de esta peticion debe ser manejada en el metodo delegado
        //restActionDidSuccessful de la clase RESTActionDelegate
        //En la cual se debe mostrar la pantalla o popup para ingresara el codigo
        //de verificacion que fue enviada SMS/EMAIL
        //Al ingresar el codigo de verificacion se debe hacer una peticion a back
        //que realiza la activación del usuario, nuevamente la respuesta debe
        //manejarse en el metodo delegado
        print("Registrando usuario")
        registerRequest()
    }
    
    @IBAction func activateAction(_ sender: Any){
        print("Activando usuario")
        activateRequest()
    }

    //MARK: - Helper methods
    func validate(){
        
    }
    
    func registerRequest(){
        let user = Usuario()
        user.nombre = txtNombre.text!
//        user.apPaterno = txtApellidos.text!
//        user.apMaterno = txtApellidos.text!
//        user.email = txtEmail.text!
//        user.usuario = txtUser.text!
//        user.contrasenia = txtPassword.text!
//        user.telLocal = txtMovil.text!
        
        do{
            let encoder = JSONEncoder()
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.registraUsuario, with: json, and: "REGISTER")
        }
        catch{
            //Mostrar popup con error
        }
    }
    
    func activateRequest(){
        let user = Usuario()
        user.idUsuario = Int(txtId.text!)
        user.codigoVerificacion = txtCodigo.text!
        
        do{
            let encoder = JSONEncoder()
            let json = try  encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.activarUsuario, with: json, and: "ACTIVATE")
        }
        catch{
            
        }
    }
    
    func initUIElements(_ elements: [UITextField?]){
        
        for text in elements {
            if let t = text{
                t.layer.borderWidth = 0.0
                t.layer.cornerRadius = 10.0
                t.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
            }            
        }

        btnRegistrar.layer.cornerRadius = 5.0
        btnActivar.layer.cornerRadius = 5.0
    }
}

extension UsuarioViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            let decoder = JSONDecoder()
            
            let result = try decoder.decode([Usuario].self, from: data)
            print(result)
        }
        catch{
            print("JSON Error: \(error)")
        }
    }
    
    func restActionDidError() {
        
    }
    
    
}
