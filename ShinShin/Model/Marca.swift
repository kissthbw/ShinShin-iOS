//
//  Marca.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/17/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class Marca: Codable, CustomStringConvertible{
    
    var idCatalogoMarca: Int?
    var nombreMarca: String?
    
    var description: String{
        return "\(idCatalogoMarca!), \(nombreMarca!)"
    }
    
    
}
