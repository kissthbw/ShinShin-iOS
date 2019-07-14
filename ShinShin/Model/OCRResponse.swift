//
//  OCRResponse.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/10/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class OCRResponse: Codable, CustomStringConvertible{
    var code: Int?
    var message: String?
    var tienda: String?
    var fecha: String?
    var hora: String?
    
    var productos = [Producto]()
    
    var description: String{
        return "\(code), \(productos.count)"
    }
}
