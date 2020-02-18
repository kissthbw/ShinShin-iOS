//
//  RecargaDetailTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class RecargaDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var txtNumero: UITextField!{
        didSet { txtNumero?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var txtCompania: UITextField!
    @IBOutlet weak var txtAlias: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    
    var item: MediosBonificacion?
    var companias = ["Telcel", "Movistar", "ATT&T", "Unefon", "Virgin Mobile"]
    let viewPicker = UIPickerView()
    
    enum UITextTags: Int{
        case TxtNumero = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showViewPicker()
        
        txtNumero.delegate = self
        txtNumero.tag = UITextTags.TxtNumero.rawValue
        
        txtAlias.delegate = self
        txtAlias.layer.cornerRadius = 10.0
        
        txtNumero.delegate = self
        txtNumero.layer.cornerRadius = 10.0
        
        txtCompania.delegate = self
        txtCompania.layer.cornerRadius = 10.0
        btnGuardar.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        txtCompania.inputAccessoryView = toolbar
        txtCompania.inputView = viewPicker
        
    }
    
    @objc func doneViewPicker(){
        self.endEditing(true)
    }
    
    @objc func cancelViewPicker(){
        self.endEditing(true)
    }
    
    func setItem(item: MediosBonificacion){
        self.item = item
    }
}

extension RecargaDetailTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return companias.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        txtCompania.text = companias[0]
        return companias[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCompania.text = companias[row]
    }
}


extension RecargaDetailTableViewCell: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.showError(false, superView: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == UITextTags.TxtNumero.rawValue{
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RecargaDetailTableViewCell{
    
    func formHasBeenUpdated() -> Bool{
        if txtNumero.text! != item?.cuentaMedioBonificacion{
            return true
        }
        
        if txtCompania.text! != item?.companiaMedioBonificacion{
            return true
        }
        
        if txtAlias.text! != item?.aliasMedioBonificacion{
            return true
        }
        return false
    }
    
    func formIsEmpty() -> Bool{
        if  Validations.isEmpty(value: txtNumero.text!) &&
            Validations.isEmpty(value: txtAlias.text!) &&
            Validations.isEmpty(value: txtCompania.text!){
            return true
        }
        else{
            return false
        }
    }
    
    func isValid() -> (valid: Bool, alert: UIAlertController?){
        if Validations.isEmpty(value: txtAlias.text!) || Validations.isEmpty(value: txtNumero.text!) || Validations.isEmpty(value: txtCompania.text!){
            
            if Validations.isEmpty(value: txtNumero.text!){
                txtNumero.showError(true, superView: false)
            }
            
            if Validations.isEmpty(value: txtCompania.text!){
                txtCompania.showError(true, superView: false)
            }
            
            if Validations.isEmpty(value: txtAlias.text!){
                txtAlias.showError(true, superView: false)
            }
            
            let alert = Validations.show(message: "Ingresa todos los datos", with: "ShingShing")
            
            return (false, alert)
        }
        
        //Telefono de 10 digitos
        if txtNumero.text!.count < 10{
            let alert = Validations.show(message: "El número debe ser de 10 posiciones", with: "ShingShing")
            
            return (false, alert)
        }
        
        return (true, nil)
    }
}
