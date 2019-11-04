//
//  UsuarioViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 4/6/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class UsuarioViewController: UITableViewController {

    //MARK: - Propiedades
    @IBOutlet weak var viewNombre: UIView!
    @IBOutlet weak var txtNombre: UITextField!
    
    @IBOutlet weak var viewCorreo: UIView!
    @IBOutlet weak var txtCorreo: UITextField!
    
    @IBOutlet weak var btnShowPlain: UIButton!
    @IBOutlet weak var imagewCheckPassword: UIImageView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnConfShowPlain: UIButton!
    @IBOutlet weak var imagewCheckConfPassword: UIImageView!
    @IBOutlet weak var viewConfPassword: UIView!
    @IBOutlet weak var txtConfPassword: UITextField!
    
    @IBOutlet weak var viewTelefono: UIView!
    @IBOutlet weak var txtTelefono: UITextField!
    
    @IBOutlet weak var viewShowPickerView: UIView!
    @IBOutlet weak var viewAnio: UIView!
    @IBOutlet weak var txtAnio: UITextField!
    @IBOutlet weak var viewDia: UIView!
    @IBOutlet weak var txtDia: UITextField!
    @IBOutlet weak var viewMes: UIView!
    @IBOutlet weak var txtMes: UITextField!
    
    @IBOutlet weak var viewSexo: UIView!
    @IBOutlet weak var txtSexo: UITextField!
    
    @IBOutlet weak var viewCP: UIView!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var switchAceptar: UISwitch!
    
    @IBOutlet weak var btnRegistrar: UIButton!
    
    weak var delegate: DismissViewControllerDelegate?
    var textFields = [UITextField]()
    var viewFields = [UIView]()
    let datePicker = UIDatePicker()
    let sexoPicker = UIPickerView()
    var sexos = [Sexo]()
    var sexo: Int = -1
    var showPassword = true
    var showConfPassword = true
    
    enum ButtonTag: Int{
        case btnPassword = 1
        case btnConfPassword = 2
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtons()
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
//        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.barStyle = .blackOpaque
        
        textFields = [txtNombre, txtCorreo, txtPassword, txtConfPassword,
         txtTelefono, txtMes, txtDia, txtAnio,
         txtSexo, txtCP]
        
        viewFields = [viewNombre, viewCorreo, viewPassword, viewConfPassword,
                      viewTelefono, viewMes, viewDia, viewAnio,
                      viewSexo, viewCP]
        
        let s1 = Sexo()
        s1.idSexo = 1
        s1.nombreSexo = "Hombre"
        
        let s2 = Sexo()
        s2.idSexo = 2
        s2.nombreSexo = "Mujer"
        sexos.append(s1)
        sexos.append(s2)
        
        initUIElements()
        showDatePicker()
        showSexoPicker()
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TerminosSegue"{
            
        }
        
        if segue.identifier == "PrivacidadSegue"{
            let vc = segue.destination as! PrivacidadViewController
            vc.origen = .Registro
        }
        
        if segue.identifier == "ActivarSegue"{
            let vc = segue.destination as! ActivacionTableViewController
            vc.mensaje = txtTelefono.text
            vc.delegate = self
        }
    }
    
    //MARK: - UI Actions
    @IBAction func showPassword(_ sender: Any) {
        let source = sender as! UIButton
        
        if source.tag == ButtonTag.btnPassword.rawValue{
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
        else if source.tag == ButtonTag.btnConfPassword.rawValue{
            if showConfPassword{
                txtConfPassword.isSecureTextEntry = true
                btnConfShowPlain.setBackgroundImage(UIImage(named: "eye-grey"), for: .normal)
                showConfPassword = !showConfPassword
            }
            else{
                txtConfPassword.isSecureTextEntry = false
                btnConfShowPlain.setBackgroundImage(UIImage(named: "eyeClose-grey"), for: .normal)
                showConfPassword = !showConfPassword
            }
        }
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func registerAction(_ sender: Any){
        
//        var formCompleta = true
//
//        //Validar datos capturados
//        for textField in textFields {
//            if textField.text == "" {
////                textField.layer.borderColor = UIColor.red.cgColor
////                textField.layer.borderWidth = 1.0
//                formCompleta = false
//                break
//            }
//        }
//
//        if !formCompleta{
//            showMessage(message: "Debes completar el formulario.", title: "ShingShing")
//
//            return
//        }
//
//        //Verificar que el switch este habilitado
//        if !switchAceptar.isOn{
//            showMessage(message: "Debes aceptar los terminos y condiciones.", title: "ShingShing")
//            return
//        }
        
        //Enviar peticion a back
        //La respuesta de esta peticion debe ser manejada en el metodo delegado
        //restActionDidSuccessful de la clase RESTActionDelegate
        //En la cual se debe mostrar la pantalla o popup para ingresara el codigo
        //de verificacion que fue enviada SMS/EMAIL
        //Al ingresar el codigo de verificacion se debe hacer una peticion a back
        //que realiza la activación del usuario, nuevamente la respuesta debe
        //manejarse en el metodo delegado
//        print("Registrando usuario")
        performSegue(withIdentifier: "ActivarSegue", sender: nil)
//        registerRequest()
    }

    @IBAction func shownDateView(_ sender: Any) {
//        showDatePicker()
        //Una vez que se despliegue el teclado
        //se mostrarara la vista personaliza para seleccionar fecha
        txtMes.isEnabled = true
        txtMes.becomeFirstResponder()
//        txtMes.isEnabled = false
    }
    
    @IBAction func verifyPassword(_ sender: Any) {
        let textField = sender as! UITextField
        if textField == txtPassword{
            print("Password")
        }
        
        if textField == txtConfPassword{
            if txtConfPassword.text == txtPassword.text{
                imagewCheckPassword.isHidden = false
                imagewCheckConfPassword.isHidden = false
            }
            else{
                imagewCheckPassword.isHidden = true
                imagewCheckConfPassword.isHidden = true
            }
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
        view.addSubview(lblBonificacion)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func showDatePicker(){
        //Formate Date
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        dateComponents.year = -100
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = -18
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtMes.inputAccessoryView = toolbar
        txtMes.inputView = datePicker
    }
    
    func showSexoPicker(){
        sexoPicker.dataSource = self
        sexoPicker.delegate = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneSexoPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelSexoPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtSexo.inputAccessoryView = toolbar
        txtSexo.inputView = sexoPicker
    }
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let fecha = formatter.string(from: datePicker.date)
        let elements = fecha.split(separator: "/")
        
        //Mes
        //Dia
        //Anio
        for (index, element) in elements.enumerated() {
            if index == 0{
                txtMes.text = element.description
            }
            else if index == 1{
                txtDia.text = element.description
            }
            else if index == 2{
                txtAnio.text = element.description
            }
        }
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        txtMes.isEnabled = false
        self.view.endEditing(true)
    }
    
    @objc func doneSexoPicker(){
        self.view.endEditing(true)
    }
    
    @objc func cancelSexoPicker(){
        self.view.endEditing(true)
    }
    
    func validate(){
        
    }
    
    @IBAction func show(_ sender: Any) {
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "PrincipalNavigationController")
//        self.navigationController!.pushViewController(destViewController, animated: true)
        self.present(destViewController, animated: true, completion: nil)
    }
    
    
    func registerRequest(){
        let user = Usuario()
        user.nombre = txtNombre.text!
        user.correoElectronico = txtCorreo.text!
        user.usuario = txtCorreo.text!
        user.contrasenia = txtPassword.text!
        user.telMovil = "+521" + txtTelefono.text!
        
        var fecNac = ""
        
        if let anio = txtAnio!.text{
            fecNac.append(anio + "-")
        }
        
        if let mes = txtMes!.text{
            fecNac.append(mes + "-")
        }
        
        if let dia = txtDia!.text{
            fecNac.append(dia)
        }
        
//        let fecNac = "\(txtAnio!.text)-\(txtMes!.text)-\(txtDia!.text)"
        user.fechaNac = fecNac
        user.codigoPostal = txtCP.text!
        user.idCatalogoSexo = 1
//        txtSexo.text
        
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
            RESTHandler.postOperationTo(RESTHandler.registrarUsuario, with: json, and: "REGISTER")
        }
        catch{
            //Mostrar popup con error
        }
    }
    
    func initUIElements(){
        
        for text in textFields {
            text.layer.cornerRadius = 10.0
            text.delegate = self
        }
        
        for view in viewFields{
            view.layer.cornerRadius = 10.0
        }

        viewShowPickerView.layer.cornerRadius = 10.0
        btnRegistrar.layer.cornerRadius = 10.0
        btnRegistrar.isEnabled = true
        switchAceptar.onTintColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1.0)
        switchAceptar.isOn = false
        imagewCheckPassword.isHidden = true
        imagewCheckConfPassword.isHidden = true
    }
}

//MARK: - Extensions
extension UsuarioViewController: DismissViewControllerDelegate{
    func didBackViewController() {
        self.delegate?.didBackViewController()
//        dismiss(animated: true, completion: nil)
//        dismiss(animated: true) {
//            self.delegate?.didBackViewController()
//        }
    }
}

extension UsuarioViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexos[row].nombreSexo
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtSexo.text = sexos[row].nombreSexo?.description
        sexo = sexos[row].idSexo!
    }
}
extension UsuarioViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtTelefono{
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            return count <= 10
        }
        else{
            return true
        }
    }
}

//MARK: - RESTActionDelegate
extension UsuarioViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        
        do{
            let decoder = JSONDecoder()
            
            let rsp = try decoder.decode(SimpleResponse.self, from: data)
            if rsp.code == 200{
                print( "Registro exitoso: \(rsp.id!)" )
                let user = Usuario()
                user.usuario = txtCorreo.text
                user.contrasenia = txtPassword.text
                user.idUsuario = rsp.id
                Model.user = user
                
                performSegue(withIdentifier: "ActivarSegue", sender: nil)
            }
            else if rsp.code == 500{
                showMessage(message: "El usuario ya existe", title: "Whoops...")
            }
        }
        catch{
            print("JSON Error: \(error)")
        }
    }
    
    func restActionDidError() {
        
    }
    
    func showMessage(message: String, title: String){
        let alert = UIAlertController(
            title: title,
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
