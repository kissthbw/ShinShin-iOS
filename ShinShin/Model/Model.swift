//
//  Model.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/20/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

class Model{
    static var user: Usuario?
    static var totalBonificacion: Double?
    static var notificaciones: [Notificacion] = [Notificacion]()
    
    init() {
        registerDefaults()
        handleFirstTime()
    }
    
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime{
            print("Primera vez")
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
            
        }
        else{
            print("Ya no es primera vez")
        }
        
    }
    
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL{
        return documentsDirectory().appendingPathComponent("ShinhShing.plist")
    }
    
    func registerDefaults(){
        let dictionary = ["FirstTime": true] as
            [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
}
