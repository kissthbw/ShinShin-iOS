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

    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var isMenuVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUser.delegate = self
        txtPassword.delegate = self
        
        txtUser.text = "kissthbw@gmail.com"
        txtPassword.text = "kiss2101"

        initUIElements()
//        configureBarButtons()
        
    }
    
    
    
    //MARK: - UI Actions
    @IBAction func signin(_ sender: Any) {
        //1. Validar campos (Habilitar boton solo cuando los campos esten llenos)
        
        //2. Realizar peticion a back
        signinRequest()
        
        //3. Habilitar acceso a pantalla principal
//        performSegue(withIdentifier: "PrincipalSegue", sender: nil)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
    
    func configureBarButtons(){
        let notif = UIBarButtonItem(
            image: UIImage(named: "notif_placeholder"),
            style: .plain,
            target: self,
            action: #selector(showMenu))
        notif.tintColor = .black
        
        let user = UIBarButtonItem(
            image: UIImage(named: "user_placeholder"),
            style: .plain,
            target: self,
            action: #selector(showMenu))
        user.tintColor = .black
        navigationItem.rightBarButtonItems = [user, notif]
    }
    
    func initUIElements(){
        viewUser.layer.cornerRadius = 10.0
        viewPassword.layer.cornerRadius = 10.0
        btnLogin.layer.cornerRadius = 10.0
//        txtUser.withImage(direction: .Left, image: UIImage(named: "img_placeholder")!, colorSeparator: UIColor.orange, colorBorder: UIColor.gray)
//
//        txtPassword.withImage(direction: .Left, image: UIImage(named: "password")!, colorSeparator: UIColor.orange, colorBorder: UIColor.gray)
//
//        txtPassword.withImage(direction: .Right, image: UIImage(named: "password-right-grey")!, colorSeparator: UIColor.orange, colorBorder: UIColor.gray)
    }
}

extension LogInViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        do{
            let decoder = JSONDecoder()
            
            //Verificar que la respuesta haya sido exitosa
            //Si lo es, dar acceso al app, sino mostrar mensaje de error
            let rsp = try decoder.decode(InformacionUsuario.self, from: data)
            if rsp.code == 200{
                Model.user = rsp.usuario
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

extension LogInViewController: SideMenuDelegate{
    
    func closeMenu() {
        isMenuVisible = !isMenuVisible
        let viewMenuBack : UIView = (self.navigationController?.view.subviews.last)!
        //            let viewMenuBack : UIView = view.subviews.last!
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = UIScreen.main.bounds.size.width
            viewMenuBack.frame = frameMenu
            viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            viewMenuBack.removeFromSuperview()
        })
    }
    
    @objc
    func showMenu(){
        
        if isMenuVisible{
            isMenuVisible = !isMenuVisible
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
        }
        else{
            isMenuVisible = !isMenuVisible
            let menuVC : SideMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewControllerOK") as! SideMenuViewController
            //        menuVC.btnMenu = sender
            menuVC.delegate = self
            self.view.addSubview(menuVC.view)
            self.addChild(menuVC)
            menuVC.view.layoutIfNeeded()
            menuVC.view.layer.shadowRadius = 2.0
            
            
            menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                menuVC.view.frame=CGRect(x: 100, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                //            sender.isEnabled = true
            }, completion:nil)
        }
        
        
    }
    
    func sideMenuItemSelectedAtIndex(_ index: Int) {
        isMenuVisible = !isMenuVisible

        switch(index){
        case 1:
            self.openViewControllerBasedOnIdentifier("PerfilTableViewController")
            break
        case 2: self.openViewControllerBasedOnIdentifier("MediosBonificacionTableViewController")
        case 3:
            self.openViewControllerBasedOnIdentifier("AyudaViewControlller")
        case 4:
            self.openViewControllerBasedOnIdentifier("ContactoViewController")
            break
        case 5:
            self.openViewControllerBasedOnIdentifier("BonificacionViewController")
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
}
