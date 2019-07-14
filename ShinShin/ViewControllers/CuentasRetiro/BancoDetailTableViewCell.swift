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
    @IBOutlet weak var txtTarjeta: UITextField!
    @IBOutlet weak var txtMes: UITextField!
    @IBOutlet weak var txtAnio: UITextField!
    
    @IBOutlet weak var viewTipo: UIView!
    @IBOutlet weak var viewMes: UIView!
    @IBOutlet weak var viewAnio: UIView!
    
    
    @IBOutlet weak var btnGuardar: UIButton!
    
    enum UITextTags: Int{
        case TxtMes = 1
        case TxtAnio = 2
        case TxtTarjeta = 3
        case TxtNombre = 4
    }
    
    var focusedTextField = -1
    
    var meses = ["01","02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var anios: [String] = [String]()
    let viewPicker = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        txtTarjeta.delegate = self
        txtNombre.delegate = self
        txtMes.delegate = self
        txtAnio.delegate = self
        
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
        txtTarjeta.layer.cornerRadius = 10.0
        viewTipo.layer.cornerRadius = 10.0
        viewMes.layer.cornerRadius = 10.0
        viewAnio.layer.cornerRadius = 10.0
        
//        showViewPicker()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == UITextTags.TxtAnio.rawValue || textField.tag == UITextTags.TxtMes.rawValue {
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
    }
}

