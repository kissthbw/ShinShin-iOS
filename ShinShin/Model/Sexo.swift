//
//  Sexo.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/29/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class Sexo: Codable, CustomStringConvertible{
    
    var idSexo: Int?
    var nombreSexo: String?
    
    var description: String{
        return "\(idSexo), \(nombreSexo)"
    }
}
