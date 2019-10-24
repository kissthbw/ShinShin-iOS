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
    @IBOutlet weak var btnSolicitar: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAgregar: UIButton!
    
    var recargas = ["$10","$20","$30","$50","$100","$200","$500"]
    var cuentas: [MediosBonificacion]? = nil
    var cuenta: MediosBonificacion? = nil
    
    enum PickerTags:Int{
        case Recarga = 1
        case Telefono = 2
    }
    let viewPicker = UIPickerView()
    let recargasPicker = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtCantidad.layer.cornerRadius = 10
        txtNumero.layer.cornerRadius = 10
        btnSolicitar.layer.cornerRadius = 10
        recargasPicker.tag = PickerTags.Recarga.rawValue
        viewPicker.tag = PickerTags.Telefono.rawValue
        
        showViewPicker()
        showRecargasPicker()
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
    
    func showRecargasPicker(){
        recargasPicker.dataSource = self
        recargasPicker.delegate = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneViewPicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelViewPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        txtCantidad.inputAccessoryView = toolbar
        txtCantidad.inputView = recargasPicker
        
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
        
        if pickerView.tag == PickerTags.Telefono.rawValue{
            if let cuentas = cuentas{
                return cuentas.count
            }
            
            return 0
        }
        
        else if pickerView.tag == PickerTags.Recarga.rawValue{
            return recargas.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == PickerTags.Telefono.rawValue{
            if let cuentas = cuentas{
                let item = cuentas[row]
                let title = item.aliasMedioBonificacion! + " - " + item.cuentaMedioBonificacion!
                return title
            }
            
            return ""
        }
        
        else if pickerView.tag == PickerTags.Recarga.rawValue{
            return recargas[row]
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == PickerTags.Telefono.rawValue{
            if let cuentas = cuentas{
                txtNumero.text = cuentas[row].aliasMedioBonificacion!
                cuenta = cuentas[row]
            }
        }
        
        else if pickerView.tag == PickerTags.Recarga.rawValue{
            txtCantidad.text = recargas[row]
        }
    }
}

