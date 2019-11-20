//
//  PayPalDetailTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PayPalDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAlias: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    var item: MediosBonificacion?
    
    let ID_LENGHT = 13
    
    enum UITextTags: Int{
        case TxtId = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtAlias.layer.cornerRadius = 10.0
        txtId.layer.cornerRadius = 10.0
        txtId.delegate = self
        txtId.tag = UITextTags.TxtId.rawValue
        
        txtEmail.layer.cornerRadius = 10.0
        btnGuardar.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setItem(item: MediosBonificacion){
        self.item = item
    }
}


extension PayPalDetailTableViewCell{
    
    func formHasBeenUpdated() -> Bool{
        if txtId.text! != item?.idCuentaMedioBonificacion{
            return true
        }
        
        if txtEmail.text! != item?.cuentaMedioBonificacion{
            return true
        }
        
        if txtAlias.text! != item?.aliasMedioBonificacion{
            return true
        }
        
        return false
    }
    
    func formIsEmpty() -> Bool{
        if  Validations.isEmpty(value: txtId.text!) &&
            Validations.isEmpty(value: txtEmail.text!) &&
            Validations.isEmpty(value: txtAlias.text!){
            return true
        }
        else{
            return false
        }
    }
    
    func isValid() -> (valid: Bool, alert: UIAlertController?){
        if Validations.isEmpty(value: txtAlias.text!) ||
            Validations.isEmpty(value: txtId.text!) ||
            Validations.isEmpty(value: txtEmail.text!){
            
            if Validations.isEmpty(value: txtId.text!){
                txtId.showError(true, superView: false)
            }
            
            if Validations.isEmpty(value: txtEmail.text!){
                txtEmail.showError(true, superView: false)
            }
            
            if Validations.isEmpty(value: txtAlias.text!){
                txtAlias.showError(true, superView: false)
            }
            
            let alert = Validations.show(message: "Ingresa todos los datos", with: "ShingShing")
            
            return (false, alert)
        }
        
        //Verificar longitud de ID de minimo y maximo 13 posiciones
        if txtId.text!.count < ID_LENGHT || txtId.text!.count > ID_LENGHT {
            let alert = Validations.show(message: "La longitud del Id debe ser de \(ID_LENGHT) posiciones", with: "ShingShing")
            
            txtId.showError(true, superView: false)
            
            return (false, alert)
        }
        
        //verificar que es correo electronico
        if !Validations.isValidEmail(emailStr: txtEmail.text!){
            let alert = Validations.show(message: "Ingrese un email válido", with: "ShingShing")
            
            txtEmail.showError(true, superView: false)
            
            return (false, alert)
        }
        
        return (true, nil)
    }
}

extension PayPalDetailTableViewCell: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.showError(false, superView: false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == UITextTags.TxtId.rawValue{
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            return count <= 13
        }
        else{
            return true
        }
    }
}
