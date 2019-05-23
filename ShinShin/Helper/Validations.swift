//
//  Validations.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 4/19/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

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
    
    
}
