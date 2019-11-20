//
//  ContactoViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/6/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class ContactoViewController: UIViewController {
    
    //MARK: - Propiedades
    @IBOutlet weak var txt1: UITextView!
    @IBOutlet weak var txt2: UITextView!
    @IBOutlet weak var btnEnviar: UIButton!
    
    let preguntasPicker = UIPickerView()
    var isMenuVisible = false
    var items: [PreguntasContacto] = [PreguntasContacto]()
    let ID_RQT_CONTACTO = "ID_RQT_CONTACTO"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        
        let item1 = PreguntasContacto()
        item1.id = 0
        item1.pregunta = "Escaneo de un Ticket"
        
        let item2 = PreguntasContacto()
        item2.id = 0
        item2.pregunta = "Transferencia / Recarga telefónica"
        
        let item3 = PreguntasContacto()
        item3.id = 0
        item3.pregunta = "Problema con la App"
        
        items.append(item1)
        items.append(item2)
        items.append(item3)
        
        initUIElements()
        configureBarButtons()
    }
    
    //MARK: - UIActions
    @IBAction func enviarAction(_ sender: Any) {
        
        if Validations.isEmpty(value: txt1.text!) ||
            Validations.isEmpty(value: txt2.text!){
         
            //Validar
            if Validations.isEmpty(value: txt1.text!){
                txt1.backgroundColor = UIColor(red: 254/255, green: 219/255, blue: 191/255, alpha: 1.0)
            }
            
            if Validations.isEmpty(value: txt2.text!){
                txt2.backgroundColor = UIColor(red: 254/255, green: 219/255, blue: 191/255, alpha: 1.0)
            }
            
            showMessage(message: "Debes aceptar los terminos y condiciones.", title: "ShingShing")
            
            return
        }
        
        if txt2.text!.count < 2{
            txt2.backgroundColor = UIColor(red: 254/255, green: 219/255, blue: 191/255, alpha: 1.0)
            
            showMessage(message: "Cuentanos un poco más.", title: "ShingShing")
            
            return
        }
    }
    
    
    //MARK: - Helper methods
    func enviarRequest(){
        do{
            RESTHandler.delegate = self
            let item = PreguntasContacto()
            item.idUsuario = Model.user?.idUsuario
            item.topico = txt1.text!
            item.detalle = txt2.text!
            
            let encoder = JSONEncoder()
            let json = try encoder.encode(item)
            
            RESTHandler.postOperationTo(RESTHandler.contacto, with: json, and: ID_RQT_CONTACTO)
        }
        catch{
            print("Error al enviar sugerencia")
        }
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
            image: UIImage(named: "notification-grey"),
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
    
    func initUIElements(){
        txt1.layer.cornerRadius = 10.0
        txt2.layer.cornerRadius = 10.0
        btnEnviar.layer.cornerRadius = 10.0
        showPicker()
    }
    
    @objc
    func showHome(){
        self.navigationController?.popToRootViewController(animated: true)
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

    func showPicker(){
        preguntasPicker.dataSource = self
        preguntasPicker.delegate = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txt1.inputAccessoryView = toolbar
        txt1.inputView = preguntasPicker
    }
    
    @objc func donePicker(){
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
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
extension ContactoViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].pregunta
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txt1.text = items[row].pregunta!
//        sexo = sexos[row].idSexo!
    }
}

//MARK: - RESTActionDelegate
extension ContactoViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        
        do{
            let decoder = JSONDecoder()
            
            let rsp = try decoder.decode(SimpleResponse.self, from: data)
            if rsp.code == 200{
                print( "Aviso de que pronto recibira una respuesta por parte de ShingShing" )
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
