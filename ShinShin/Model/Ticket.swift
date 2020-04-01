//
//  Ticket.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/17/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class HistoricoTicket: Codable{
    var code: Int?
    var message: String?
    var id: Int?
    var tickets: [Ticket]? = [Ticket]()
}

class PhotoItem: Codable{
    var identifier: String?
    var imageData: String?
}

class Ticket: Codable, CustomStringConvertible{
    var nombreTienda: String?
    var sucursal: String?
    var fecha: String?
//    var hora: String?
    var subtotal: Double?
    var iva: Double?
    var total: Double?
    var ticket_tienda: String?
    var ticket_subTienda: String?
    var ticket_transaccion: String?
    var ticket_fecha: String?
    var ticket_hora: String?
    
    var productos: [Producto]?
    var ticketPhotos: [PhotoItem]?
    
    var description: String{
        return "\(nombreTienda)"
    }
}
