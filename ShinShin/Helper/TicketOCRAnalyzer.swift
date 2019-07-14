//
//  TicketOCRAnalyzer.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/1/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class TicketOCRAnalyzer{
    
    static let comercios = [
        "OXXO":"OXXO",
        "Oxx0":"OXXO",
        "Oxxa":"OXXO",
        "Oxxo":"OXXO",
        "GxD":"OXXO"
    ]
    /*
     */
    static func analize(_ lines: [String]){
        //Iterar sobre las lineas de texto para encontrar los siguientes
        //puntos de validacion
        //Caso 1: OXXO
        //Comercio: Cadena comercial OXXO [Oxx0][0xx0][0XX0]
        //Fecha: dd/mm/aaaa hh:mm
        //Productos: [nombre_producto] [cantidad]
        
        for line in lines {
            //Determinar el comercio
            detectarComercio(line)
            
        }
    }
    
    static func detectarComercio(_ line: String){
        for (key, value) in comercios {
            if line.contains(key){
                print("El comercio es un: \(value)")
            }
        }
    }
}
