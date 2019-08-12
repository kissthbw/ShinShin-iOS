//
//  TipoBancaria.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/20/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class ListaTipoBancaria: Codable{
    var code: Int?
    var message: String?
    var id: Int?
    var tiposBancarias: [TipoBancaria]?
}

class TipoBancaria: Codable, CustomStringConvertible {
    var idTipo: Int?
    var descripcionBancaria: String?
    
    var description: String{
        return "\(idTipo!), \(descripcionBancaria!)"
    }
}
