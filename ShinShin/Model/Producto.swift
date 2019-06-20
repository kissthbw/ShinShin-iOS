//
//  Producto.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 5/8/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class ProductoArray: Codable{
    var code: Int?
    var message: String?
    var id: Int?
    var productos = [Producto]()
}

//Codable es un alias para encodable y decodable, necesario para el parseo de JSONs
//CustomStringCovertible para un print de la clase
class Producto: Codable, CustomStringConvertible{
    var idProducto: Int?
    var nombreProducto: String?
    var precio: Double?
    var codigoBarras: String?
    var presentacion: String?
    var contenido: String?
    var descripcion: String?
    var urlImagenProducto: String?
    var cantidadBonificacion: Double?
    var catalogoMarca: Marca?
    var catalogoTipoProducto: TipoProducto?
    var catalogoTienda: CatalogoTiendas?
    
    var description: String{
        return "ID: \(idProducto!), Nombre: \(nombreProducto!)"
    }
    
    
}
