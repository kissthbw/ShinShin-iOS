//
//  CatalogoDepartamentos.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/18/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class CatalogoDepartamentosArray: Codable{
    var code: Int?
    var message: String?
    var id: Int?
    var tipoProductos = [CatalogoDepartamentos]()
}

class CatalogoDepartamentos: Codable, CustomStringConvertible {
    
    var idCatalogoTipoProducto: Int?
    var nombreTipoProducto: String?
    var imagen: String?
    
    var description: String{
        return "\(idCatalogoTipoProducto!), \(nombreTipoProducto!)"
    }
}
