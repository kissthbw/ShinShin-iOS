//
//  PerfilTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/15/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class PerfilTableViewController: UITableViewController {

    //MARK: - Propiedades
    @IBOutlet weak var imageViewPerfil: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    
    @IBOutlet weak var txtMes: UITextField!
    @IBOutlet weak var txtDia: UITextField!
    @IBOutlet weak var txtAnio: UITextField!
    @IBOutlet weak var viewCumple: UIView!
    @IBOutlet weak var viewAnio: UIView!
    @IBOutlet weak var viewDia: UIView!
    @IBOutlet weak var viewMes: UIView!
    @IBOutlet weak var txtSexo: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var txtPasswordActual: UITextField!
    @IBOutlet weak var txtPasswordNuevo: UITextField!
    @IBOutlet weak var txtConfirmarPasswordNuevo: UITextField!

//    @IBOutlet weak var imageCheckActualPassword: UIImageView!
    @IBOutlet weak var imageCheckPassword: UIImageView!
    @IBOutlet weak var imageCheckConfPassword: UIImageView!
    @IBOutlet weak var btnGuardar: UIButton!
    let datePicker = UIDatePicker()
    let sexoPicker = UIPickerView()
    var sexos = [Sexo]()
    var sexo: Int = -1
    
    var isMenuVisible = false
    var showPassword = false
    var showNuevoPassword = false
    var showConfNuevoPassword = false
    let password_lenght = 8
    var enviaPassword = false
    
    enum ButtonTag: Int{
        case btnPasswordActual = 1
        case btnPassword = 2
        case btnConfPassword = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        let textfields = [txtNombre, txtCorreo,
                          txtTelefono, txtSexo, txtPasswordActual, txtPasswordNuevo, txtConfirmarPasswordNuevo, txtCP]
        
        txtNombre.delegate = self
        txtCorreo.delegate = self
        txtTelefono.delegate = self
        txtMes.delegate = self
        txtDia.delegate = self
        txtAnio.delegate = self
        txtCP.delegate = self
        txtSexo.delegate = self
        txtPasswordActual.delegate = self
        txtPasswordNuevo.delegate = self
        txtConfirmarPasswordNuevo.delegate = self
        
        let s1 = Sexo()
        s1.idSexo = 1
        s1.nombreSexo = "Hombre"
        
        let s2 = Sexo()
        s2.idSexo = 2
        s2.nombreSexo = "Mujer"
        sexos.append(s1)
        sexos.append(s2)
        
        initUIElements(textfields)
        configureBarButtons()
    }

    //MARK: - UI Actions
    @IBAction func actualizarAction(_ sender: Any) {
        //Agregar validaciones
        if Validations.isEmpty(value: txtNombre.text!) || Validations.isEmpty(value: txtCorreo.text!) ||
            Validations.isEmpty(value: txtTelefono.text!) ||
            Validations.isEmpty(value: txtMes.text!) ||
            Validations.isEmpty(value: txtCP.text!){
            let alert = Validations.show(message: "Ingresa todos los campos", with: "ShingShing")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        //Verificar el password nuevo en caso de existir
        if verifyPassword(){
            actualizarRequest()
        }
    }
    
    @IBAction func showPassword(_ sender: Any) {
        let source = sender as! UIButton
        
        if source.tag == ButtonTag.btnPasswordActual.rawValue{
            if showPassword{
                txtPasswordActual.isSecureTextEntry = true
                showPassword = !showPassword
            }
            else{
                txtPasswordActual.isSecureTextEntry = false
                showPassword = !showPassword
            }
        }
        else if source.tag == ButtonTag.btnPassword.rawValue{
            if showNuevoPassword{
                txtPasswordNuevo.isSecureTextEntry = true
                showNuevoPassword = !showNuevoPassword
            }
            else{
                txtPasswordNuevo.isSecureTextEntry = false
                showNuevoPassword = !showNuevoPassword
            }
        }
        else if source.tag == ButtonTag.btnConfPassword.rawValue{
            if showConfNuevoPassword{
                txtConfirmarPasswordNuevo.isSecureTextEntry = true
                showConfNuevoPassword = !showConfNuevoPassword
            }
            else{
                txtConfirmarPasswordNuevo.isSecureTextEntry = false
                showConfNuevoPassword = !showConfNuevoPassword
            }
        }
    }
    
    @IBAction func validatePassword(_ sender: Any) {
        if txtPasswordNuevo.text == txtConfirmarPasswordNuevo.text{
            imageCheckPassword.isHidden = false
            imageCheckConfPassword.isHidden = false
        }
        else{
            imageCheckPassword.isHidden = true
            imageCheckConfPassword.isHidden = true
        }
    }
    
    
    @IBAction func shownDateView(_ sender: Any) {
        //        showDatePicker()
        //Una vez que se despliegue el teclado
        //se mostrarara la vista personaliza para seleccionar fecha
        txtMes.isEnabled = true
        txtMes.becomeFirstResponder()
    }
    
    @IBAction func mostrarCamaraAction(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.imageViewPerfil.image = image
        }
    }
    
    
    //MARK: - Helper methods
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
    
    @objc func doneSexoPicker(){
        self.view.endEditing(true)
    }
    
    @objc func cancelSexoPicker(){
        self.view.endEditing(true)
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
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
    
    func verifyPassword() -> Bool {

        //Si alguno de los password esta ingresado
        //Se debe validar que todos sean ingresados
        //y
        if Validations.isEmpty(value: txtPasswordActual.text! ) &&
            Validations.isEmpty(value: txtPasswordNuevo.text! ) &&
            Validations.isEmpty(value: txtConfirmarPasswordNuevo.text! ){
            print("No se cambio password")
            
            return true
        }
        else{
            if !Validations.isEmpty(value: txtPasswordActual.text! ) &&
                !Validations.isEmpty(value: txtPasswordNuevo.text! ) &&
                !Validations.isEmpty(value: txtConfirmarPasswordNuevo.text! ) {
                print("Validando passwords")
                
                if txtPasswordNuevo.text!.count < password_lenght ||
                    txtConfirmarPasswordNuevo.text!.count < password_lenght{
                    let alert = Validations.show(message: "La longitud del password debe ser de \(password_lenght)", with: "ShingShing")
                    self.present(alert, animated: true, completion: nil)
                    enviaPassword = false
                    return false
                }
                
                enviaPassword = true
                return true
            }
            else{
                let alert = Validations.show(message: "Ingresa la informacion de los passwords", with: "ShingShing")
                self.present(alert, animated: true, completion: nil)
                enviaPassword = true
                return false
            }
        }
    }
    
    func actualizarRequest(){
        do{
            let user = Usuario()
            user.idUsuario = Model.user?.idUsuario
            user.nombre = txtNombre.text
            user.correoElectronico = txtCorreo.text
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

            user.fechaNac = fecNac
            user.codigoPostal = txtCP.text
            user.idCatalogoSexo = sexo

            let imageData = imageViewPerfil.image?.jpegData(compressionQuality: 0.3)
            let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
            
            user.imageData = strBase64
            
            if enviaPassword{
                user.contraseniaActual = txtPasswordActual.text
                user.contrasenia = txtPasswordNuevo.text
            }
            
            let encoder = JSONEncoder()
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.actualizarUsuario, with: json, and: "ACTUALIZAR")
        }
        catch{
            //Mostrar popup con error
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
        
        showDatePicker()
        showSexoPicker()
        
        viewMes.layer.cornerRadius = 10.0
        viewDia.layer.cornerRadius = 10.0
        viewAnio.layer.cornerRadius = 10.0
        viewCumple.layer.cornerRadius = 10.0
        
        imageViewPerfil.layer.cornerRadius = imageViewPerfil.frame.size.width/2
        imageViewPerfil.clipsToBounds = true
        if let imageURL = Model.user?.imgUrl{
            imageViewPerfil.loadImage(url: URL(string: imageURL)!)
        }
        
        btnGuardar.layer.cornerRadius = 10.0
        //        btnActivar.layer.cornerRadius = 5.0
        
        txtNombre.text = Model.user?.nombre
        txtCorreo.text = Model.user?.correoElectronico
        let tel = Model.user?.telMovil?.replacingOccurrences(of: "+521", with: "")
        txtTelefono.text = tel
        
        if let elements = Model.user?.fechaNac?.split(separator: "-"){
            for (index, element) in elements.enumerated() {
                if index == 0{
                    txtAnio.text = element.description
                }
                else if index == 1{
                    txtMes.text = element.description
                }
                else if index == 2{
                    txtDia.text = element.description
                }
            }
        }
        
        if let idSexo = Model.user?.idCatalogoSexo{
            txtSexo.text = sexos[idSexo-1].nombreSexo?.description
            self.sexo = idSexo
        }
        
        txtCP.text = Model.user?.codigoPostal
        imageCheckPassword.isHidden = true
        imageCheckConfPassword.isHidden = true
//
//        if Model.idRedSocial == -1{
//            btnGuardar.isHidden = false
//        }
//        else{
//            btnGuardar.isHidden = true
//        }
    }
    
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
            image: UIImage(named: "bar-notif-grey"),
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
    func showHome(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func showView(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "BonificacionViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showNotif(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showMenu(){
        present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Extensions
extension PerfilTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
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

extension PerfilTableViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PerfilTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        do{
            let decoder = JSONDecoder()
            
            let rsp = try decoder.decode(InformacionUsuario.self, from: data)
            if rsp.code == 200{
                Model.user = rsp.usuario
                Model.perfilActualizado = true
                self.navigationController?.popToRootViewController(animated: true)
            }
            else if rsp.code == 202{
                showMessage(message: "El password actual es incorrecto", title: "ShingShing")
            }
            else{
                showMessage(message: "Ocurrió un error, intenta mas tarde", title: "ShingShing")
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
