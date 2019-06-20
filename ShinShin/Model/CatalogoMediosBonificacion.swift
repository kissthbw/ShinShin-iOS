//
//  CatalogoMediosBonificacion.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/17/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class CatalogoMediosBonificacionArray: Codable{
    var code: Int?
    var message: String?
    var id: Int?
    var mediosBonificacion = [CatalogoMediosBonificacion]()
}

class CatalogoMediosBonificacion: Codable, CustomStringConvertible {
    
    var idCatalogoMedioBonificacion: Int?
    var nombreMedioBonificacion: String?
    
    var description: String{
        return "\(idCatalogoMedioBonificacion!), \(nombreMedioBonificacion!)"
    }
}
