//
//  EliminarPerfilTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 8/24/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class EliminarPerfilTableViewController: UITableViewController {

    //MARK: - Propiedades
    @IBOutlet weak var txtMotivo: UITextField!
    @IBOutlet weak var txtComentarios: UITextField!
    @IBOutlet weak var btnEliminar: UIButton!
    
    enum TextFields{
        case txtMotivo
        case txtComentarios
    }
    
    let ID_RQT_ELIMINAR = "ID_RQT_ELIMINAR"
    var motivos: [String] = [ "Tengo otra cuenta Shing Shing",
        "Casi no utilizo la App",
        "Faltan productos en la App",
        "Otro" ]
    let comentarios: [String] = [String]()
    let viewPicker = UIPickerView()
    var textFocused: TextFields = .txtMotivo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtons()
        initUI()
        showViewPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - UI Actions
    @IBAction func eliminarPerfil(_ sender: Any) {
        
        //Validar que se haya seleccionado el motivo
        if Validations.isEmpty(value: txtMotivo.text!){
            txtMotivo.showError(true, superView: false)
            self.tableView.endEditing(true)
            showMessage(message: "Debes seleccionar un motivo")

            return
        }

        eliminarPerfilRequest()
//        performSegue(withIdentifier: "ConfirmarEliminarSegue", sender: self)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToHome(_ sender: Any) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - HelperMethods
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
    
    @objc
    func showHome(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func eliminarPerfilRequest(){
        let user = Usuario()
        user.idUsuario = Model.user?.idUsuario

        
        do{
            let encoder = JSONEncoder()
            let json = try  encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.eliminarUsuario, with: json, and: ID_RQT_ELIMINAR)
        }
        catch{
            
        }
    }
    
    func initUI(){
        txtMotivo.delegate = self
        txtComentarios.delegate = self
        
        txtMotivo.layer.cornerRadius = 10.0
        txtComentarios.layer.cornerRadius = 10.0
        btnEliminar.layer.cornerRadius = 10.0
    }
    
    func showViewPicker(){
        viewPicker.dataSource = self
        viewPicker.delegate = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneViewPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelViewPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtMotivo.inputAccessoryView = toolbar
        txtMotivo.inputView = viewPicker
        
//        txtComentarios.inputAccessoryView = toolbar
//        txtComentarios.inputView = viewPicker
    }
    
    @objc func doneViewPicker(){
        self.tableView.endEditing(true)
    }
    
    @objc func cancelViewPicker(){
        self.tableView.endEditing(true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}

//MARK: - Extensions
extension EliminarPerfilTableViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.showError(false, superView: false)
        
        if textField == txtMotivo{
            textFocused = .txtMotivo
        }
        
        if textField == txtComentarios{
            textFocused = .txtComentarios
        }
    }
}

extension EliminarPerfilTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if textFocused == .txtMotivo{
            return motivos.count
        }
        else{
            return comentarios.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if textFocused == .txtMotivo{
            return motivos[row]
        }
        else{
            return comentarios[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if textFocused == .txtMotivo{
            txtMotivo.text = motivos[row]
        }
        else{
            txtComentarios.text = comentarios[row]
        }
        
    }
}

extension EliminarPerfilTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {

        do{
            let decoder = JSONDecoder()
            
            if identifier == ID_RQT_ELIMINAR{
                let rsp = try decoder.decode(SimpleResponse.self, from: data)
                if rsp.code == 200{
                    performSegue(withIdentifier: "ConfirmarEliminarSegue", sender: self)
                }
                else {
                    showMessage(message: "Ocurrió un error, intentar nuevamente")
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
            title: "Shing Shing",
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

