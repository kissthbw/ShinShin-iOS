//
//  BancoBonificacionTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/25/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BancoBonificacionTableViewCell: UITableViewCell {

    @IBOutlet weak var txtCantidad: UITextField!
    @IBOutlet weak var txtCuenta: UITextField!
    @IBOutlet weak var btnSolicitar: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAgregar: UIButton!
    
    var cuentas: [MediosBonificacion]? = nil
    var cuenta: MediosBonificacion? = nil
    let viewPicker = UIPickerView()
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    enum UITextTags: Int{
        case TxtCantidad = 10
    }
    
    struct LENGHT{
        static let MONTO_MIN = 2
        static let MONTO_MAX = 3
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtCantidad.delegate = self
        txtCuenta.delegate = self
        txtCantidad.tag = UITextTags.TxtCantidad.rawValue
        txtCantidad.layer.cornerRadius = 10.0
        txtCuenta.layer.cornerRadius = 10.0
        btnSolicitar.layer.cornerRadius = 10
        showViewPicker()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Helper methods
    func showViewPicker(){
        viewPicker.dataSource = self
        viewPicker.delegate = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneViewPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelViewPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtCuenta.inputAccessoryView = toolbar
        txtCuenta.inputView = viewPicker

    }
    
    @objc func doneViewPicker(){
        self.endEditing(true)
    }
    
    @objc func cancelViewPicker(){
        self.endEditing(true)
    }
}

extension BancoBonificacionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let cuentas = cuentas{
            return cuentas.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let cuentas = cuentas{
            let item = cuentas[row]
            let title = item.aliasMedioBonificacion! + " - " + item.cuentaMedioBonificacion!
            return title
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let cuentas = cuentas{
            txtCuenta.text = cuentas[row].aliasMedioBonificacion!
            cuenta = cuentas[row]
        }
    }
}

extension BancoBonificacionTableViewCell{
    func clean(){
        txtCantidad.text = ""
        txtCuenta.text = ""
    }
    
    func formIsEmpty() -> Bool{
        if  Validations.isEmpty(value: txtCantidad.text!) &&
            Validations.isEmpty(value: txtCuenta.text!){
            return true
        }
        else{
            return false
        }
    }
    
    func isValid() -> (valid: Bool, alert: UIAlertController?){
        if Validations.isEmpty(value: txtCantidad.text!) ||
            Validations.isEmpty(value: txtCuenta.text!){
            
            if Validations.isEmpty(value: txtCantidad.text!){
                txtCantidad.showError(true, superView: false)
            }
            
            if Validations.isEmpty(value: txtCuenta.text!){
                txtCuenta.showError(true, superView: false)
            }
            
            let alert = Validations.show(message: "Ingresa todos los datos", with: "ShingShing")

            return (false, alert)
        }
        
        //Validar nombre corto, de al menos 1 posicion
        //La cantidad debe ser de 10 a 500 pesos
//        let cantidad = txtCantidad.text!
        let cantidad = Int(txtCantidad.text!)
        if let cantidad = cantidad{
            if cantidad < 10 || cantidad > 500{
                let alert = Validations.show(message: "La cantidad permita debe ser entre $10 y $500", with: "ShingShing")

                return (false, alert)
            }
        }
        
        
        return (true, nil)
    }
}

extension BancoBonificacionTableViewCell: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("editing")
        textField.showError(false, superView: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        
        if textField.tag == UITextTags.TxtCantidad.rawValue{
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            
            return count <= LENGHT.MONTO_MAX
            
        }
        else{
            return true
        }
    }
}
