//
//  Validations.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 4/19/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation
import UIKit

/*
 Esta clase contiene metodos de validacion como:
 Obligatoriedad.
 Longitud.
 Estructura (email, tarjetas, telefonos).
 Similitud entre 2 valores
 */

class Validations{
    
    /*
     Verifica si el valor es nulo o vacio
     Regresa true, si el valor es nulo o vacio, false si el campo contiene
     un valor
     */
    class func isEmpty(value: String) -> Bool{
        if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            return true
        }
        
        return false
    }
    
    class func formatWith(_ valor: Double?) -> String{
        if let valor = valor{
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let tmp = NSNumber(value: valor)
            if let formatValue = formatter.string(from: tmp){
                let tmp = "$ " + formatValue + " "
                return tmp
            }
            return "$ 0.0 "
        }
        else{
            return "$ 0.0 "
        }
    }
    
    class func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    class func show(message: String, with title: String) -> UIAlertController{
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let action =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: nil)
        
        alert.addAction(action)
        return alert
    }
}
