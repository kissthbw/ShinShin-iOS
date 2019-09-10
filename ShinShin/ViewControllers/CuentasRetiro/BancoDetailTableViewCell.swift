//
//  BancoDetailTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BancoDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var txtNombre: UITextField!
    
    //La longitud de este campo es variable
    //CLABE:    18 posiciones
    //TARJETA:  16 posiciones
    //CUENTA:   11 posiciones
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var txtTarjeta: UITextField!
    @IBOutlet weak var txtMes: UITextField!
    @IBOutlet weak var txtAnio: UITextField!
    
    @IBOutlet weak var viewTipo: UIView!
    @IBOutlet weak var viewMes: UIView!
    @IBOutlet weak var viewAnio: UIView!
    
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    
    enum UITextTags: Int{
        case TxtMes = 1
        case TxtAnio = 2
        case TxtTarjeta = 3
        case TxtNombre = 4
        case TxtTipo = 5
    }
    
    enum TipoCuenta: Int{
        case clabe = 18
        case cuenta = 11
        case tarjeta = 16
    }
    
    let ID_RQT_TIPOS = "ID_RQT_TIPOS"
    var tipoCuentaSelected: TipoCuenta = .clabe
    var focusedTextField = -1
    var idTipo = -1
    
    var meses = ["01","02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var anios: [String] = [String]()
    
    var listTiposBancaria: [TipoBancaria] = [TipoBancaria]()
    var idTipoBancaria = -1
//    var tipoCuenta = ["CLABE","CUENTA","TARJETA"]
    
    let viewPicker = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        txtTipo.delegate = self
        txtTarjeta.delegate = self
        txtNombre.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        txtNombre.delegate = self
        txtMes.delegate = self
        txtAnio.delegate = self
        
        txtTipo.tag = UITextTags.TxtTipo.rawValue
        txtMes.tag = UITextTags.TxtMes.rawValue
        txtAnio.tag = UITextTags.TxtAnio.rawValue
        txtTarjeta.tag = UITextTags.TxtTarjeta.rawValue
        txtTarjeta.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        txtNombre.tag = UITextTags.TxtNombre.rawValue
        
        for _ in 1...10 {
            anios.append(String(year))
            year = year + 1
        }
        
        btnGuardar.layer.cornerRadius = 10.0
        txtTipo.layer.cornerRadius = 10.0
        txtTarjeta.layer.cornerRadius = 10.0
        viewTipo.layer.cornerRadius = 10.0
        viewMes.layer.cornerRadius = 10.0
        viewAnio.layer.cornerRadius = 10.0
        
        obtieneTiposBancariaRequest()
//        showViewPicker()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Actions
    @objc func textFieldChanged(_ textField: UITextField){
        
        if textField.text?.count == 2{
            //Si empieza con 4 es Visa
            let string = textField.text!
            var tmp = string.prefix(1)
            if tmp == "4"{
                print("Es visa")
            }
            
            tmp = string.prefix(2)
            if tmp == "51"{
                print("Es mastercard")
            }
            
            //Si empeiza con 51, 52, 53, 54 es MasterCard
        }
        
        
    }

    //MARK: - Helper methods
    func obtieneTiposBancariaRequest(){
        do{
            RESTHandler.delegate = self
            RESTHandler.getOperationTo(RESTHandler.obtieneTiposBancarias, and: ID_RQT_TIPOS)
        }
        catch{
            
        }
    }
    
    func showViewPicker(){
        viewPicker.dataSource = self
        viewPicker.delegate = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneViewPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelViewPicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        txtMes.inputAccessoryView = toolbar
        txtMes.inputView = viewPicker
        
        txtAnio.inputAccessoryView = toolbar
        txtAnio.inputView = viewPicker
        
        txtTipo.inputAccessoryView = toolbar
        txtTipo.inputView = viewPicker
    }
    
    @objc func doneViewPicker(){
        self.endEditing(true)
    }
    
    @objc func cancelViewPicker(){
        self.endEditing(true)
    }
}

//MARK: - Extensions
extension BancoDetailTableViewCell: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == UITextTags.TxtTarjeta.rawValue{
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            if tipoCuentaSelected == .clabe{
                return count <= 18
            }
            else if tipoCuentaSelected == .tarjeta{
                return count <= 16
            }
            else if tipoCuentaSelected == .cuenta{
                return count <= 11
            }
            return true
            
        }
        else{
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == UITextTags.TxtAnio.rawValue || textField.tag == UITextTags.TxtMes.rawValue || textField.tag == UITextTags.TxtTipo.rawValue {
            focusedTextField = textField.tag
            showViewPicker()
        }
        
    }
}

extension BancoDetailTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if focusedTextField == UITextTags.TxtMes.rawValue{
            return meses.count
        }
        else if focusedTextField == UITextTags.TxtAnio.rawValue{
            return anios.count
        }
        else if focusedTextField == UITextTags.TxtTipo.rawValue{
            return listTiposBancaria.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if focusedTextField == UITextTags.TxtMes.rawValue{
            return meses[row]
        }
        else if focusedTextField == UITextTags.TxtAnio.rawValue{
            return anios[row]
        }
        else if focusedTextField == UITextTags.TxtTipo.rawValue{
            return listTiposBancaria[row].descripcionBancaria
        }
        else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if focusedTextField == UITextTags.TxtMes.rawValue{
            txtMes.text = meses[row]
        }
        else if focusedTextField == UITextTags.TxtAnio.rawValue{
            txtAnio.text = anios[row]
        }
        else if focusedTextField == UITextTags.TxtTipo.rawValue{
            txtTarjeta.text = ""
            let tipo = listTiposBancaria[row]
            txtTipo.text = tipo.descripcionBancaria
            idTipoBancaria = tipo.idTipo!
            //"CLABE","CUENTA","TARJETA"
            if ( tipo.descripcionBancaria == "CLABE" ){
                tipoCuentaSelected = .clabe
                
            }
            else if ( tipo.descripcionBancaria == "CUENTA" ){
                tipoCuentaSelected = .cuenta
            }
            else {
                tipoCuentaSelected = .tarjeta
            }
        }
    }
}

extension BancoDetailTableViewCell: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            if( identifier == "ID_RQT_TIPOS" ){
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(ListaTipoBancaria.self, from: data)
                if let list = rsp.tiposBancarias{
                    listTiposBancaria = list
                    
                    if idTipo > -1{
                        
                        for item in listTiposBancaria{
                            if item.idTipo! == idTipo{
                                self.txtTipo.text = item.descripcionBancaria
                            }
                        }
                        
                        
                    }
                }
            }
        }
        catch{
            print("JSON Error: \(error)")
        }
    }
    
    func restActionDidError() {
        self.showNetworkError()
    }
    
    func showNetworkError(){
        let alert = UIAlertController(
            title: "Whoops...",
            message: "Ocurrió un problema." +
            " Favor de interntar nuevamente",
            preferredStyle: .alert)
        
        let action =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: nil)
        
        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
    }
}
