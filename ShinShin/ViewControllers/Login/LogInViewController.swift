//
//  LogInViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 3/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

/*
 La funcionalidad general de esta clase es:
 Consumo del servicio de validación de usuario
 Consumo del servicio de log in via facebook
 Validación de obligatoriedad
 Permitir el registro de nuevos usuarios
 */

import UIKit


class LogInViewController: UIViewController {

    //MARK: - Propiedades
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnShowPlain: UIButton!
    
    var isMenuVisible = false
    var showPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUser.delegate = self
        txtPassword.delegate = self
        
        txtUser.text = "kissthbw@gmail.com"
        txtPassword.text = "kiss2101"

        initUIElements()
    }
    
    //MARK: - Actions
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    
    @IBAction func showPlain(_ sender: Any) {
        if showPassword{
            txtPassword.isSecureTextEntry = true
            btnShowPlain.setBackgroundImage(UIImage(named: "password-right-grey"), for: .normal)
            showPassword = !showPassword
        }
        else{
            txtPassword.isSecureTextEntry = false
            btnShowPlain.setBackgroundImage(UIImage(named: "password-right-orange"), for: .normal)
            showPassword = !showPassword
        }
    }
    //270, 13
    //22, 22
    
    @IBAction func signin(_ sender: Any) {
        //1. Validar campos (Habilitar boton solo cuando los campos esten llenos)
        
        //2. Realizar peticion a back
        signinRequest()
        
        //3. Habilitar acceso a pantalla principal
//        performSegue(withIdentifier: "PrincipalSegue", sender: nil)
    }
    
    //MARK: - Helper methods
    func signinRequest(){
        let user = Usuario()
        user.usuario = txtUser.text!
        user.contrasenia = txtPassword.text!
        
        do{
            let encoder = JSONEncoder()
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.login2, with: json, and: "SIGNIN")
        }
        catch{
            //Mostrar popup con error
        }
    }
    
    func initUIElements(){
        viewUser.layer.cornerRadius = 10.0
        viewPassword.layer.cornerRadius = 10.0
        btnLogin.layer.cornerRadius = 10.0
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}

//MARK: - Extensions
//MARK: - RESTActionDelegate
extension LogInViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        do{
            let decoder = JSONDecoder()
            
            //Verificar que la respuesta haya sido exitosa
            //Si lo es, dar acceso al app, sino mostrar mensaje de error
            let rsp = try decoder.decode(InformacionUsuario.self, from: data)
            if rsp.code == 200{
                Model.user = rsp.usuario
                Model.totalBonificacion = rsp.bonificacion
                performSegue(withIdentifier: "PrincipalSegue", sender: nil)
            }
            else{
                showMessage(message: "Credenciales inválidas")
            }
            
        }
        catch{
            print("JSON Error: \(error)")
        }
        
    }
    
    func showMessage(message: String){
        let alert = UIAlertController(
            title: "Whoops...",
            message: message,
            preferredStyle: .alert)
        
        let action =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func restActionDidError() {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
}

extension LogInViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
