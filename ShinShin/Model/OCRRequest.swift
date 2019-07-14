//
//  OCRRequest.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/10/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class OCRRequest: Codable, CustomStringConvertible{
    
    var lineas: [String]? = [String]()
    
    var description: String{
        return "Elementos: \(lineas?.count)"
    }
}
