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
    let motivos: [String] = [String]()
    let comentarios: [String] = [String]()
    let viewPicker = UIPickerView()
    var textFocused: TextFields = .txtMotivo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        showViewPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - UI Actions
    @IBAction func eliminarPerfil(_ sender: Any) {
        eliminarPerfilRequest()
//        performSegue(withIdentifier: "ConfirmarEliminarSegue", sender: self)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - HelperMethods
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
        
        txtComentarios.inputAccessoryView = toolbar
        txtComentarios.inputView = viewPicker
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
