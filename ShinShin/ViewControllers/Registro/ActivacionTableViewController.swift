//
//  ActivacionTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/28/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ActivacionTableViewController: UITableViewController {

    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var txtField1: UITextField!
    @IBOutlet weak var txtField2: UITextField!
    @IBOutlet weak var txtField3: UITextField!
    @IBOutlet weak var txtField4: UITextField!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var v4: UIView!
    @IBOutlet weak var btnValidar: UIButton!
    
    weak var delegate: DismissViewControllerDelegate?
    var mensaje: String?
    let ID_RQT_ACTIVAR = "ID_RQT_ACTIVAR"
    let ID_RQT_REENVIAR = "ID_RQT_REENVIAR"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtons()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        
        lblMensaje.text = "Te enviámos un SMS a [telefono] con un código de verificación"
        
        if let mensaje = mensaje{
            if mensaje.count == 10{
                let index = mensaje.index(mensaje.startIndex, offsetBy:
                    6)
                var mask = mensaje[index..<mensaje.endIndex]
                print("\(mask)")
                mask = "****" + mask
                
                let replaced = lblMensaje.text!.replacingOccurrences(of: "[telefono]", with: mask)
                lblMensaje.text = replaced
            }
            
        }
        
        txtField1.delegate = self
        txtField2.delegate = self
        txtField3.delegate = self
        txtField4.delegate = self
        
        v1.layer.cornerRadius = 10.0
        v2.layer.cornerRadius = 10.0
        v3.layer.cornerRadius = 10.0
        v4.layer.cornerRadius = 10.0
        btnValidar.layer.cornerRadius = 10.0
        
        txtField1.tag = 1
        txtField2.tag = 2
        txtField3.tag = 3
        txtField4.tag = 4
        
        txtField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txtField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txtField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txtField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VerificacionSegue"{
            let vc = segue.destination as! VerificacionViewController
            vc.delegate = self
        }
    }
    
    //MARK: - UI Actions
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func activateAction(_ sender: Any){
        print("Activando usuario")
        activateRequest()
        
//        performSegue(withIdentifier: "VerificacionSegue", sender: self)
        
        //1. Dismiss
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reenviarAction(_ sender: Any){
        print("Reenviando codigo")
        reenviarCodigoRequest()
    }
    
    //Helper methods
    func activateRequest(){
        let user = Usuario()
        user.idUsuario = Model.user?.idUsuario
        let c1 = txtField1.text!
        let c2 = txtField2.text!
        let c3 = txtField3.text!
        let c4 = txtField4.text!
        
        user.codigoVerificacion = c1 + c2 + c3 + c4
        
        do{
            let encoder = JSONEncoder()
            let json = try  encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.activarUsuario, with: json, and: ID_RQT_ACTIVAR)
        }
        catch{
            
        }
    }
    
    func reenviarCodigoRequest(){
        let user = Usuario()
        user.idUsuario = Model.user?.idUsuario
        
        do{
            let encoder = JSONEncoder()
            let json = try  encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.reenviarCodigo, with: json, and: ID_RQT_REENVIAR)
        }
        catch{
            
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if text?.utf16.count==1{
            switch textField{
            case txtField1:
                txtField2.becomeFirstResponder()
            case txtField2:
                txtField3.becomeFirstResponder()
            case txtField3:
                txtField4.becomeFirstResponder()
            case txtField4:
                txtField4.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }
    }
    
    //MARK: - Helper methods
    func configureBarButtons(){
            let img = UIImage(named: "back")
            let imageView = UIImageView(image: img)
            imageView.frame = CGRect(x: 0, y: 6, width: 12, height: 21)
            
            let lblBonificacion = UILabel()
            lblBonificacion.font = UIFont(name: "Nunito SemiBold", size: 15)
    //        lblBonificacion.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
            lblBonificacion.textColor = .systemBlue
            
            lblBonificacion.text = "Inicio"
            lblBonificacion.sizeToFit()
            
            let frame = lblBonificacion.frame
            lblBonificacion.frame = CGRect(x: 21, y: 6, width: frame.width, height: frame.height)
            
            //El tamanio del view debe ser
            //lblBonificacion.width + imageView.x + imageView.width + 4(que debe ser lo mismo que imageView.x
            let width = lblBonificacion.frame.width + imageView.frame.minX +
                imageView.frame.width + imageView.frame.minX
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 32))
    //        view.layer.cornerRadius = 10.0
    //        view.layer.borderWidth = 1.0
    //        view.layer.borderColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0).cgColor
            view.addSubview(imageView)
//            view.addSubview(lblBonificacion)
            let button = UIButton(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height))
            button.addTarget(self, action: #selector(back), for: .touchUpInside)
            view.addSubview(button)
            
            self.navigationItem.titleView = view
            
            let back = UIBarButtonItem(customView: view)
            
    //        let home = UIBarButtonItem(
    //            image: UIImage(named: "logo-menu"),
    //            style: .plain,
    //            target: self,
    //            action: #selector(back))
    //        home.tintColor = .black
            
            
    //        navigationItem.rightBarButtonItems = [user, notif]
            navigationItem.leftBarButtonItems = [back]
        }
        
        @objc func back(){
            self.navigationController?.popViewController(animated: true)
        }
}

//MARK: - Extensions
extension ActivacionTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if( textField.text?.count == 1 ){
//            txtField1.resignFirstResponder()
//            txtField2.becomeFirstResponder()
//            return true
//        }
        
        return true
//        return textField.shouldChangeCustomOtp(textField: textField, string: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("End")
    }
}

extension UITextField {
    func shouldChangeCustomOtp(textField:UITextField, string: String) ->Bool {
        
        //Check if textField has two chacraters
        if ((textField.text?.count)! == 0  && string.count > 0) {
            let nextTag = textField.tag + 1;
            
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag);
            if (nextResponder == nil) {
                nextResponder = textField.superview?.viewWithTag(1);
            }
            
            textField.text = textField.text! + string;
            //write here your last textfield tag
            if textField.tag == 2 {
                //Dissmiss keyboard on last entry
                textField.resignFirstResponder()
            }
            else {
                ///Appear keyboard
                nextResponder?.becomeFirstResponder();
            }
            return false;
        } else if ((textField.text?.count)! == 0  && string.count == 0) {// on deleteing value from Textfield
            
            let previousTag = textField.tag - 1;
            // get prev responder
            var previousResponder = textField.superview?.viewWithTag(previousTag);
            if (previousResponder == nil) {
                previousResponder = textField.superview?.viewWithTag(1);
            }
            textField.text = "";
            previousResponder?.becomeFirstResponder();
            return false
        }
        return true
        
    }
    
}

//MARK: - RESTActionDelegate
extension ActivacionTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        
        do{
            let decoder = JSONDecoder()
            
            if identifier == ID_RQT_ACTIVAR{
                let rsp = try decoder.decode(SimpleResponse.self, from: data)
                if rsp.code == 200{
                    performSegue(withIdentifier: "VerificacionSegue", sender: self)
                }
                else if rsp.code == 500{
                    showMessage(message: "El usuario ya existe")
                }
            }
                
            else if identifier == ID_RQT_REENVIAR{
                let rsp = try decoder.decode(SimpleResponse.self, from: data)
                if rsp.code == 200{
                    print("Codigo reenviado")
                }
            }
        }
        catch{
            print("JSON Error: \(error)")
        }
    }
    
    func restActionDidError() {
        
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
    
}

extension ActivacionTableViewController: DismissViewControllerDelegate{
    func didBackViewController() {
//        dismiss(animated: true){
//            self.delegate?.didBackViewController()
//        }
        self.delegate?.didBackViewController()
    }
}
