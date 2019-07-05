//
//  InformacionUsuario.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/20/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class InformacionUsuario: Codable, CustomStringConvertible{
    var code: Int?
    var message: String?
    var id: Int?
    var bonificacion: Double?
    var usuario: Usuario?
    
    var description: String{
        return "\(code!), \(message!)"
    }
}
