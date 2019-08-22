//
//  Bonificacion.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/25/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class HistoricoBonificacion: Codable{
    var code: Int?
    var message: String?
    var id: Int?
    var historicoMediosBonificaciones: [Bonificacion]? = [Bonificacion]()
}

class Bonificacion: Codable, CustomStringConvertible{

    var idHistoricoMediosBonificacion: Int?
    var fechaBonificacion: String?
//    var horaBonificacion: String?
    var cantidadBonificacion: Double?
    var mediosBonificacion: MediosBonificacion?
    var usuario: Usuario?
    
    var description: String{
        return "\(fechaBonificacion!)"
    }
}
