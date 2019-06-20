//
//  Ticket.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/17/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class Ticket: Codable, CustomStringConvertible{
    var nombreTienda: String?
    var sucursal: String?
    var fecha: String?
    var hora: String?
    var subtotal: Double?
    var iva: Double?
    var total: Double?
    var productos: [Producto]?
    
    var description: String{
        return "\(nombreTienda)"
    }
}
