//
//  Producto.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 4/16/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class UsuarioArray: Codable{
    var list = [Usuario]()
}

class Usuario: Codable, CustomStringConvertible{
    
    var idUsuario: Int?
    var nombre: String?
    var apPaterno: String?
    var apMaterno: String?
    var fechaNac: String?
    var usuario: String?
    var contrasenia: String?
    var calle: String?
    var numeroExt: String?
    var numeroInt: String?
    var colonia: String?
    var codigoPostal: String?
    var delMun: String?
    var estado: String?
    var telMovil: String?
    var correoElectronico: String?
    var codigoVerificacion: String?
    var idCatalogoSexo: Int?
    
    //Para el guardado del ticket
    var tickets: [Ticket]?
    
    var description: String{
        return "(ID: \(idUsuario!), nombre: \(nombre!))"
    }
    
    
}
