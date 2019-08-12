//
//  MediosBonificacion.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/17/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class MediosBonificacionRSP: Codable{
    var code: Int?
    var message: String?
    var id: Int?
    var mediosBonificacion: [MediosBonifiacionPorUsuario]?
}

class MediosBonifiacionPorUsuario: Codable{
    var nombreMedioBonificacion: String?
    var list: [MediosBonificacion]?
}

class MediosBonificacion: Codable, CustomStringConvertible{
    var idMediosBonificacion: Int?
    var cuentaMedioBonificacion: String?
    var companiaMedioBonificacion: String?
    var aliasMedioBonificacion: String?
    var vigenciaMedioBonificacion: String?
    var idCuentaMedioBonificacion: String?
    var idTipo: Int?
    
    var catalogoMediosBonificacion: CatalogoMediosBonificacion?
    var usuario: Usuario?
    
    var description: String{
        return "\(idMediosBonificacion!), \(cuentaMedioBonificacion!)"
    }
}
