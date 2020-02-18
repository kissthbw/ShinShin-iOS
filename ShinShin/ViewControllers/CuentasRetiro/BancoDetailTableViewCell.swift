//
//  BancoDetailTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BancoDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTitulo: UILabel!
    //La longitud de este campo es variable
    //CLABE:    18 posiciones
    //TARJETA:  16 posiciones
    //CUENTA:   11 posiciones
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var txtTarjeta: UITextField!{
        didSet { txtTarjeta?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var txtTarjetaTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTarjetaTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTarjeta: UILabel!
    @IBOutlet weak var txtBanco: UITextField!
    @IBOutlet weak var txtAlias: UITextField!
    @IBOutlet weak var imgCheck: UIImageView!
    
    @IBOutlet weak var viewScanner: UIView!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    var item: MediosBonificacion?
    
    enum UITextTags: Int{
        case TxtTipo = 1
        case TxtTarjeta = 2
        case TxtBanco = 3
        case TxtAlias = 4
    }
    
    enum TipoCuenta: Int{
        case clabe = 18
        case cuenta = 11
        case tarjeta = 16
    }
    
    struct LENGHT{
        static let CLABE = 18 //19, 11
        static let TARJETA_MASKED = 19
        static let TARJETA = 16
        static let CUENTA = 11
    }
    
    let ID_RQT_TIPOS = "ID_RQT_TIPOS"
    var tipoCuentaSelected: TipoCuenta = .clabe
    var focusedTextField = -1
    var idTipo = -1
    
    var bancos = ["BBVA","SANTANDER", "BANCO AZTECA", "SCOTIA BANK", "HSBC"]
    
    var listTiposBancaria: [TipoBancaria] = [TipoBancaria]()
    var idTipoBancaria = -1
//    var tipoCuenta = ["CLABE","CUENTA","TARJETA"]
    
    let viewPicker = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUIElements()
        obtieneTiposBancariaRequest()
//        showViewPicker()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setItem(item: MediosBonificacion){
        self.item = item
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
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }

    //MARK: - Helper methods
    func initUIElements(){
        imgCheck.alpha = 0.0
        txtTipo.delegate = self
        txtTarjeta.delegate = self
        txtBanco.delegate = self
        txtAlias.delegate = self

        txtTipo.tag = UITextTags.TxtTipo.rawValue
        txtTarjeta.tag = UITextTags.TxtTarjeta.rawValue
        txtBanco.tag = UITextTags.TxtBanco.rawValue
        txtAlias.tag = UITextTags.TxtAlias.rawValue
        
        viewScanner.layer.cornerRadius = 10.0
        btnGuardar.layer.cornerRadius = 10.0
        txtTipo.layer.cornerRadius = 10.0
        txtTarjeta.layer.cornerRadius = 10.0
        txtBanco.layer.cornerRadius = 10.0
        txtAlias.layer.cornerRadius = 10.0
    }
        
    func obtieneTiposBancariaRequest(){
        RESTHandler.delegate = self
        RESTHandler.getOperationTo(RESTHandler.obtieneTiposBancarias, and: ID_RQT_TIPOS)
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
//        let is456 = string.hasPrefix("1")
//
//        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
//        // as 4-6-5-4 to err on the side of always letting the user type more digits.
//        let is465 = [
//            // Amex
//            "34", "37",
//
//            // Diners Club
//            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
//            ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
//        let is4444 = !(is456 || is465)
        let is4444 = true
        let is456 = false
        let is465 = false
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
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
        txtBanco.inputAccessoryView = toolbar
        txtBanco.inputView = viewPicker
        
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
        
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        
        if textField.tag == UITextTags.TxtTarjeta.rawValue{
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            if tipoCuentaSelected == .clabe{
                if count >= LENGHT.CLABE{
                    imgCheck.alpha = 1.0
                }
                else{
                    imgCheck.alpha = 0.0
                }
                
                return count <= LENGHT.CLABE
            }
            else if tipoCuentaSelected == .tarjeta{
                if count >= LENGHT.TARJETA_MASKED{
                    imgCheck.alpha = 1.0
                }
                else{
                    imgCheck.alpha = 0.0
                }
                
                return count <= LENGHT.TARJETA_MASKED
            }
            else if tipoCuentaSelected == .cuenta{
                if count >= LENGHT.CUENTA{
                    imgCheck.alpha = 1.0
                }
                else{
                    imgCheck.alpha = 0.0
                }
                
                return count <= LENGHT.CUENTA
            }
            return true
            
        }
        else{
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.showError(false, superView: false)
        
        if textField.tag == UITextTags.TxtBanco.rawValue || textField.tag == UITextTags.TxtTipo.rawValue {
            focusedTextField = textField.tag
            showViewPicker()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension BancoDetailTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if focusedTextField == UITextTags.TxtBanco.rawValue{
            return bancos.count
        }
        else if focusedTextField == UITextTags.TxtTipo.rawValue{
            return listTiposBancaria.count
        }
        else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if focusedTextField == UITextTags.TxtBanco.rawValue{
            txtBanco.text = bancos[0]
            return bancos[row]
        }
        else if focusedTextField == UITextTags.TxtTipo.rawValue{
            txtTarjeta.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
            txtTarjeta.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
            tipoCuentaSelected = .tarjeta
            let tipo = listTiposBancaria[0]
            txtTipo.text = tipo.descripcionBancaria
            return listTiposBancaria[row].descripcionBancaria
        }
        else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if focusedTextField == UITextTags.TxtBanco.rawValue{
            txtBanco.text = bancos[row]
        }
        else if focusedTextField == UITextTags.TxtTipo.rawValue{
            txtTarjeta.text = ""
            let tipo = listTiposBancaria[row]
            txtTipo.text = tipo.descripcionBancaria
            idTipoBancaria = tipo.idTipo!
//            txtTarjeta.becomeFirstResponder()
            
            //"CLABE","CUENTA","TARJETA"
            if ( tipo.descripcionBancaria == "CLABE" ){
                txtTarjeta.removeTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
                txtTarjeta.removeTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
                txtTarjeta.text = ""
                imgCheck.alpha = 0.0
                lblTarjeta.text = "No. de CLABE"
                tipoCuentaSelected = .clabe
                animateScanView(true)
            }
            else if ( tipo.descripcionBancaria == "Cuenta" ){
                tipoCuentaSelected = .cuenta
                
                txtTarjeta.removeTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
                txtTarjeta.removeTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
                txtTarjeta.text = ""
                lblTarjeta.text = "No. de Cuenta"
                animateScanView(true)
            }
            else {
                txtTarjeta.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
                txtTarjeta.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
                lblTarjeta.text = "No. de Tarjeta"
                tipoCuentaSelected = .tarjeta
                animateScanView(false)
            }
        }
    }
    
    func animateScanView(_ hide: Bool){
        var percent: CGFloat = 1.0
        var constraint: CGFloat = 62.67
        var imgConstraint: CGFloat = 67.7
        if hide{
            percent = 0.0
            constraint = 0.0
            imgConstraint = 5.0
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0, options: [.curveEaseIn],
                       animations: {
                        
                        if hide{
                            self.viewScanner.alpha = percent
                        }
                        else{
                            self.txtTarjetaTrailingConstraint.constant = constraint
                            self.checkTrailingConstraint.constant = imgConstraint
                            self.lblTarjetaTrailingConstraint.constant = constraint
                            self.contentView.setNeedsLayout()
                            self.contentView.layoutIfNeeded()
                        }
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
                if hide{
                    self.txtTarjetaTrailingConstraint.constant = constraint
                    self.checkTrailingConstraint.constant = imgConstraint
                    self.lblTarjetaTrailingConstraint.constant = constraint
                    self.contentView.setNeedsLayout()
                    self.contentView.layoutIfNeeded()
                }
                else{
                    self.viewScanner.alpha = percent
                }
                
            }, completion: nil)
        })
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

extension BancoDetailTableViewCell{
    func formHasBeenUpdated() -> Bool{
        if txtAlias.text! != item?.aliasMedioBonificacion{
            return true
        }
        return false
    }
    
    func formIsEmpty() -> Bool{
        if  Validations.isEmpty(value: txtTipo.text!) &&
            Validations.isEmpty(value: txtAlias.text!) &&
            Validations.isEmpty(value: txtTarjeta.text!) &&
            Validations.isEmpty(value: txtBanco.text!){
            return true
        }
        else{
            return false
        }
    }
    
    func isValid() -> (valid: Bool, alert: UIAlertController?){
        if Validations.isEmpty(value: txtAlias.text!) ||
            Validations.isEmpty(value: txtTarjeta.text!) ||
            Validations.isEmpty(value: txtBanco.text!){
            
            if Validations.isEmpty(value: txtTipo.text!){
                txtTipo.showError(true, superView: false)
            }
            
            if Validations.isEmpty(value: txtAlias.text!){
                txtAlias.showError(true, superView: false)
            }
            
            if Validations.isEmpty(value: txtTarjeta.text!){
                txtTarjeta.showError(true, superView: false)
            }
            
            if Validations.isEmpty(value: txtBanco.text!){
                txtBanco.showError(true, superView: false)
            }
            
            let alert = Validations.show(message: "Ingresa todos los datos", with: "ShingShing")

            return (false, alert)
        }
        
        //Verificar longitud del tipo de cuenta
        if tipoCuentaSelected == .clabe && txtTarjeta.text!.count < LENGHT.CLABE{
            txtTarjeta.showError(true, superView: false)
            let alert = Validations.show(message: "La longitud debe ser de \(LENGHT.CLABE) posiciones.", with: "ShingShing")

            return (false, alert)
        }
        
        if tipoCuentaSelected == .cuenta && txtTarjeta.text!.count < LENGHT.CUENTA{
            txtTarjeta.showError(true, superView: false)
            let alert = Validations.show(message: "La longitud debe ser de \(LENGHT.CUENTA) posiciones.", with: "ShingShing")

            return (false, alert)
        }
        
        if tipoCuentaSelected == .cuenta && txtTarjeta.text!.count < LENGHT.TARJETA{
            txtTarjeta.showError(true, superView: false)
            let alert = Validations.show(message: "La longitud debe ser de \(LENGHT.TARJETA) posiciones.", with: "ShingShing")

            return (false, alert)
        }
        
        if tipoCuentaSelected == .clabe && txtTarjeta.text!.count < LENGHT.CLABE{
            txtTarjeta.showError(true, superView: false)
            let alert = Validations.show(message: "La longitud debe ser de \(LENGHT.CLABE) posiciones.", with: "ShingShing")

            return (false, alert)
        }
        
        //Validar nombre corto, de al menos 1 posicion
        //
        
        return (true, nil)
    }
}
