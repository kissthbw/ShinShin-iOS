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
    static var idRedSocial: Int?
    static var perfilActualizado: Bool = false
    static var mantenerCamara = false
    static var logout = false
    
    init() {
        registerDefaults()
//        handleFirstTime()
    }
    
    class func isFirtsTime() -> Bool{
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        return firstTime
    }
    
    class func handleFirstTime(){
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
    
    class func getUsuario() -> Usuario?{
        let item = Usuario()
        let userDefaults = UserDefaults.standard
        let usuario = userDefaults.string(forKey: "usuario")
        let hash = userDefaults.string(forKey: "hash")
        let idRedSocial = userDefaults.integer(forKey: "idRedSocial")
        let idUsuario = userDefaults.integer(forKey: "idUsuario")
        userDefaults.synchronize()
        
        item.usuario = usuario
        item.hash = hash
        item.idRedSocial = idRedSocial
        item.idUsuario = idUsuario
        
        return item
    }
    
    class func updateUsuario( item: Usuario ){
        let userDefaults = UserDefaults.standard

        userDefaults.set(item.usuario, forKey: "usuario")
        userDefaults.set(item.hash, forKey: "hash")
        userDefaults.set(item.idRedSocial, forKey: "idRedSocial")
        userDefaults.set(item.idUsuario, forKey: "idUsuario")
        
        userDefaults.synchronize()
    }
    
    class func resetUsuario(){
        let userDefaults = UserDefaults.standard

        userDefaults.set("-1", forKey: "usuario")
        userDefaults.set("-1", forKey: "hash")
        userDefaults.set(-1, forKey: "idRedSocial")
        userDefaults.set(-1, forKey: "idUsuario")
        
        userDefaults.synchronize()
    }
    
    
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL{
        return documentsDirectory().appendingPathComponent("ShinhShing.plist")
    }
    
    func registerDefaults(){
    
        let dictionary = ["FirstTime": true,
                          "idRedSocial": -1,
                          "idUsuario":-1,
                          "usuario":"-1",
                          "hash":"-1"] as
            [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
}
