//
//  CatalogoTiendas.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/18/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class CatalogoTiendasArray: Codable{
    var code: Int?
    var message: String?
    var id: Int?
    var tiendas = [CatalogoTiendas]()
}

class CatalogoTiendas: Codable, CustomStringConvertible {
    
    var idCatalogoTienda: Int?
    var nombreTienda: String?
    var imagenTienda: String?
    
    var description: String{
        return "\(idCatalogoTienda!), \(nombreTienda!)"
    }
}
