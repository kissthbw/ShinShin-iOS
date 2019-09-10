//
//  RecargaDetailTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class RecargaDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtNumero: UITextField!{
        didSet { txtNumero?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var txtCompania: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    
    var companias = ["TELCEL", "MOVISTAR", "ATT&T", "UNEFON", "VIRGIN MOBILE"]
    let viewPicker = UIPickerView()
    
    enum UITextTags: Int{
        case TxtNumero = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showViewPicker()
        
        txtNumero.delegate = self
        txtNumero.tag = UITextTags.TxtNumero.rawValue
        
        txtNombre.layer.cornerRadius = 10.0
        txtNumero.layer.cornerRadius = 10.0
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
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        txtCompania.inputAccessoryView = toolbar
        txtCompania.inputView = viewPicker
        
    }
    
    @objc func doneViewPicker(){
        self.endEditing(true)
    }
    
    @objc func cancelViewPicker(){
        self.endEditing(true)
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
        return companias[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCompania.text = companias[row]
    }
}


extension RecargaDetailTableViewCell: UITextFieldDelegate{
    
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
}
