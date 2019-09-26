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
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class LogInViewController: UIViewController {

    //MARK: - Propiedades
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnShowPlain: UIButton!
//    @IBOutlet weak var btnGoogleSignIn: GIDSignInButton!
    @IBOutlet weak var viewMail: UIView!
    @IBOutlet weak var viewGoogle: UIView!
    @IBOutlet weak var viewFacebook: UIView!
    
    var isMenuVisible = false
    var showPassword = true
    var idRedSocial = -1
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
//        let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
//        if statusBar?.responds(to: #selector(setter: UIView.backgroundColor)) ?? false {
//            statusBar?.backgroundColor =  UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
//        }
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

//        let loginButton = FBLoginButton(permissions: [.publicProfile, .email])
//        loginButton.delegate = self
//        loginButton.center = view.center
//        self.view.addSubview(loginButton)
//        if let accessToken = AccessToken.current {
//            // User is already logged in with facebook
//            print("User is already logged in")
//            print(accessToken)
//        }
        
//        let loginButton = FBLoginButton(readPermissions: [.publicProfile])

        
        // Automatically sign in the user.
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        txtUser.delegate = self
        txtPassword.delegate = self
        
        txtUser.text = "kissthbw@gmail.com"
        txtPassword.text = "kiss2101"

        initUIElements()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LogInViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
    }
    
    //MARK: - Actions
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    
    @IBAction func showPlain(_ sender: Any) {
        if showPassword{
            txtPassword.isSecureTextEntry = false
            btnShowPlain.setBackgroundImage(UIImage(named: "eye-grey"), for: .normal)
            showPassword = !showPassword
        }
        else{
            txtPassword.isSecureTextEntry = true
            btnShowPlain.setBackgroundImage(UIImage(named: "eyeClose-grey"), for: .normal)
            showPassword = !showPassword
        }
    }
    //270, 13
    //22, 22
    
    @IBAction func signin(_ sender: Any) {
        //1. Validar campos (Habilitar boton solo cuando los campos esten llenos)
        if Validations.isEmpty(value: txtUser.text!) || Validations.isEmpty(value: txtPassword.text!){
            
            showMessage(message: "Ingresa todos los datos")
            
            return
        }
        
        //2. Realizar peticion a back
        let user = Usuario()
        user.usuario = txtUser.text!
        user.contrasenia = txtPassword.text!
        signinRequest(with: user)
        
        //3. Habilitar acceso a pantalla principal
//        performSegue(withIdentifier: "PrincipalSegue", sender: nil)
    }
    
    
    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signInFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        
        
        
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print(grantedPermissions)
                print(declinedPermissions)
                print(accessToken)
                
                self.showFacebookDetails(token: accessToken.tokenString)
                
                
                print("Logged in!")
            }
            print("User logged in")
        }
    }
    
    //MARK: - Helper methods
    func showFacebookDetails(token: String){
        let req = GraphRequest(graphPath: "me",
                               parameters: ["fields": "email,first_name,last_name,gender,picture"],
                               tokenString: token, version: "", httpMethod: HTTPMethod.get)
        
        req.start { (connection, result, error) in
            if error == nil {
                if let responseDictionary = result as? NSDictionary {
                    
                    let firstName = responseDictionary["first_name"] as? String ?? "User"
                    let lastName = responseDictionary["last_name"] as? String ?? ""
                    let email = responseDictionary["email"] as? String ?? ""
                    let gender = responseDictionary["gender"] as? String ?? ""
                    let id = responseDictionary["id"] as! String
                    
                    var pictureUrl = ""
                    if let picture = responseDictionary["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                        pictureUrl = url
                        
                    }
                    
                    let su = Usuario()
                    su.nombre = firstName + " " + lastName
                    su.fechaNac = "1970-01-01"
                    su.telMovil = "+5215555555555"
                    su.correoElectronico = email
                    su.usuario = email
                    su.contrasenia = email
                    su.codigoPostal = "00000"
                    su.idRedSocial = 2
                    su.idCatalogoSexo = 3
                    self.idRedSocial = 2
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        self.processSocialMediaSignIn(su)
                    }
                }
            }else{
                print("error in graph request:", error)
                
            }
        }
    }
    
    func signinRequest(with user: Usuario){
//        let user = Usuario()
//        user.usuario = txtUser.text!
//        user.contrasenia = txtPassword.text!
        
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
//        btnGoogleSignIn.style = .iconOnly
//        let btnSize : CGFloat = 100
//        
//        var btnSignIn = UIButton(frame: CGRect(x: 0,y: 0,width: btnSize,height: btnSize))
//        btnSignIn.center = view.center
//        btnSignIn.setImage(UIImage(named: "gmail"), for: .normal)
//        btnSignIn.addTarget(self, action: #selector(btnSignInPressed), for: .touchUpInside)
//        
//        btnGoogleSignIn.addSubview(btnSignIn)
        
        let alpha = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
        let final = UIColor(red: 254/255, green: 219/255, blue: 191/255, alpha: 1.0)
        
        let gradient = CAGradientLayer(start: .bottomLeft, end: .center, colors: [final.cgColor, alpha.cgColor], type: .axial)
        gradient.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient)
        
        viewMail.layer.cornerRadius = 10.0
        viewGoogle.layer.cornerRadius = 10.0
        viewFacebook.layer.cornerRadius = 10.0
        cardView.layer.cornerRadius = 15.0
        viewUser.layer.cornerRadius = 10.0
        viewPassword.layer.cornerRadius = 10.0
        btnLogin.layer.cornerRadius = 10.0
    }
    
    @objc
    func btnSignInPressed() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func GLogOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegistroSegue"{
            let navigation = segue.destination as! UINavigationController
            let vc = navigation.viewControllers.first as! UsuarioViewController
            vc.delegate = self
//            let vc = segue.destination as! UsuarioViewController
//            vc.delegate = self
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        
        print("Procesando notificacion")
        
        if notification.name.rawValue == "ToggleAuthUINotification" {
            if notification.userInfo != nil {
                guard let su = notification.userInfo as? [String:Any] else { return }
                
                //Realizar inicio de sesion en back
                //se debe verificar que el usuario exista, de no ser asi
                //se guarda la informacion devuelta por google
                let user = su["user"] as? Usuario
                do{
                    let encoder = JSONEncoder()
                    let json = try encoder.encode(user)
                    RESTHandler.delegate = self
                    RESTHandler.postOperationTo(RESTHandler.registrarSocialUsuario, with: json, and: "REGISTER")
                }
                catch{
                    //Mostrar popup con error
                }
            }
            print("Saliendo de notificacion...")
        }
    }
    
    func processSocialMediaSignIn(_ user: Usuario){
        do{
            print("Procesando SignIn")
            let encoder = JSONEncoder()
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.registrarSocialUsuario, with: json, and: "REGISTER")
        }
        catch{
            //Mostrar popup con error
        }
    }
}

//MARK: - Extensions
extension LogInViewController: DismissViewControllerDelegate{
    func didBackViewController() {
        //Iniciar sesion con nuevo usuario registrado
//        print("Usuaario registrado: \(Model.user?.usuario), \(Model.user?.contrasenia)")
        
        let user = Usuario()
        user.usuario = Model.user?.usuario
        user.contrasenia = Model.user?.contrasenia
        signinRequest(with: user)
        
        self.dismiss(animated: true){
            self.signinRequest(with: user)
        }
        
        //Lanzar servicio de login
    }
}

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
                Model.idRedSocial = self.idRedSocial //Google = 1, Facebook = 2
                print("Entrando...")
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
        showMessage(message: "Error al conectar al servidor")
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

//MARK: - Facebook SignIn
//extension LogInViewController: LoginButtonDelegate{
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        let permissions = result?.grantedPermissions
//
//        if let permissions = permissions{
//            for val in permissions {
//                print(val)
//            }
//        }
//
//        print("User logged in")
//
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        print("User logged out")
//    }
//}

//MARK: - Google SignIn
extension LogInViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            return
        }
        
        
        //El usuario ShingShing necesita:
        //nombre - user.profile.name
        //fecha de nacimiento - Asignar un generico
        //tel_movil - Asignar un generico
        //correo_electronico user.profile.email
        //usuario - user.profile.email
        //contrasenia - user.profile.email
        //codigo_postal - Asignar un generico
        //estatus - Activo por default
        //codigo verificacion - Asignar un generico
        let su = Usuario()
        su.nombre = user.profile.name
        su.fechaNac = "1970-01-01"
        su.telMovil = "+5215555555555"
        su.correoElectronico = user.profile.email
        su.usuario = user.profile.email
        su.contrasenia = user.profile.email
        su.codigoPostal = "00000"
        su.idRedSocial = 1
        su.idCatalogoSexo = 3
        self.idRedSocial = 1
        
        // Perform any operations on signed in user here.
        //        let userId = user.userID                  // For client-side use only!
        //        let idToken = user.authentication.idToken // Safe to send to the server
        //        let fullName = user.profile.name
        //        let givenName = user.profile.givenName
        //        let familyName = user.profile.familyName
        //        let email = user.profile.email
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.processSocialMediaSignIn(su)
        }
        
//        NotificationCenter.default.post(
//            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
//            object: nil,
//            userInfo: ["user": su])
        print("Saliendo de metodo delegado de Google")
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
    }
}
