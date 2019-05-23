//
//  RESTHelper.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 4/15/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

protocol RESTActionDelegate: class {
    func restActionDidSuccessful(data: Data)
    func restActionDidError()
}

/*
 Esta clase helper concentrara las operaciones básicas REST
 del API ShinShin
 */
class RESTHandler{
    
    static weak var delegate: RESTActionDelegate?
    
    //Lista de URIs del API
    static let server = ""
    
    //Usuario
    static let usuariosList = "http://localhost:8080/shin-back/usuarios/list"
    static let guardaUsuario = "http://localhost:8080/shin-back/usuarios/usuario/guardar"
    
    //Productos
//    static let obtieneProductos = "http://localhost:8080/ShinBack/productos/list"
    static let obtieneProductos = "https://www.google.com.mx"
    
    class func getOperationTo(_ urlString: String){
        
        let url = URL(string: urlString)
        print("Get operation to URI: \(url!)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request){ (data, response, error) in
            if let error = error as NSError?, error.code == -999{
                print( "Error: \(error)" )
                self.delegate?.restActionDidError()
                return
            }
            else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200{
                DispatchQueue.main.async {
                    print( "Response: \(httpResponse)" )
                    self.delegate?.restActionDidSuccessful(data: data! as Data)
                }
                
            }
            else{
                DispatchQueue.main.async {
                    self.delegate?.restActionDidError()
                }
            }
            
        }
        
        dataTask.resume()
    }
    
    class func postOperationsTo(_ urlString: String, with data: Data){
        let url = URL(string: urlString)
        
        print("Post operation to URI: \(url!)")
        
        var request = URLRequest(url: url!);
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
//        request.httpBody = object
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request){ (data, response, error) in
            if let error = error as NSError?, error.code == -999{
                return
            }
            else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200{
                print( "Exito" )
            }
            else{
                print( "Ocurrio un error" )
            }
            
        }
        
        dataTask.resume()
    }
}
