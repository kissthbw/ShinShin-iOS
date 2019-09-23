//
//  FAQ.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/22/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class FAQ: Codable, CustomStringConvertible{
    var pregunta: String?
    var respuesta: String?
    
    var description: String{
        return "\(pregunta)"
    }
}
