//
//  RecargaBonificacionTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/25/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class RecargaBonificacionTableViewCell: UITableViewCell {

    @IBOutlet weak var txtCantidad: UITextField!
    @IBOutlet weak var txtNumero: UITextField!
    @IBOutlet weak var txtCompania: UITextField!
    @IBOutlet weak var btnSolicitar: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAgregar: UIButton!
    
    
    var cuentas: [MediosBonificacion]? = nil
    var cuenta: MediosBonificacion? = nil
    let viewPicker = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtCantidad.layer.cornerRadius = 10
        txtNumero.layer.cornerRadius = 10
        txtCompania.layer.cornerRadius = 10
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
        txtNumero.inputAccessoryView = toolbar
        txtNumero.inputView = viewPicker
        
    }
    
    @objc func doneViewPicker(){
        self.endEditing(true)
    }
    
    @objc func cancelViewPicker(){
        self.endEditing(true)
    }
}

extension RecargaBonificacionTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
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
            txtNumero.text = cuentas[row].aliasMedioBonificacion!
            cuenta = cuentas[row]
        }
    }
}

