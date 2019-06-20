//
//  TipoProducto.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/17/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class TipoProducto: Codable, CustomStringConvertible{
    var idCatalogoTipoProducto: Int?
    var nombreTipoProducto: String?
    
    var description: String{
        return "\(idCatalogoTipoProducto), \(nombreTipoProducto)"
    }
}
