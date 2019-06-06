//
//  RESTHelper.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 4/15/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import Foundation

/*
 Protocolo que deben implementar las clases que hagan uso de RESTHandler
 permite manejar las respuestas exitosas y de error generadas por las
 operaciones de esta clase.
 Los metodos del protocolo son llamados dentro del handler del dataTask
 lo que significa que son llamados de forma asincrona.
 */
protocol RESTActionDelegate: class {
    //Es llamado cuando el resultado del request es igual a 200
    func restActionDidSuccessful(data: Data, identifier: String)
    
    //Es llamado cuando ocurrio algun error en el request
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
    static let obtieneUsuarios = "http://localhost:8080/shin-back/usuarios/list"
    static let signin = "http://localhost:8080/shin-back/sign"
    static let registraUsuario = "http://localhost:8080/shin-back/usuarios/usuario/registrar"
    static let activarUsuario = "http://localhost:8080/shin-back/usuarios/usuario/activar"
    
    //Productos
    //http://shinshin-env.m7izq9trpe.us-east-2.elasticbeanstalk.com
    static let obtieneProductos = "http://shinshin-env.m7izq9trpe.us-east-2.elasticbeanstalk.com/productos/list"
    
    //Ticket
    static let obtieneTicketsPorUsuario = ""
    static let registrarTicket = ""
    
    //Aplicar bonificaciones
    static let solicitarBonificacion = ""
    
    class func getOperationTo(_ urlString: String, and identifier: String){
        
        let url = URL(string: urlString)
        print("Get operation to URI: \(url!)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request){ (data, response, error) in
            if let error = error as NSError?, error.code == -999{
                print( "Error: \(error)" )
                DispatchQueue.main.async {
                    self.delegate?.restActionDidError()
                }
//                return
            }
            else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200{
                DispatchQueue.main.async {
                    print( "Response: \(httpResponse)" )
                    self.delegate?.restActionDidSuccessful(data: data! as Data, identifier: identifier)
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
    
    class func postOperationTo(_ urlString: String, with data: Data, and identifier: String){
        let url = URL(string: urlString)
        
        print("Post operation to URI: \(url!)")
        
        var request = URLRequest(url: url!);
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request){ (data, response, error) in
            if let error = error as NSError?, error.code == -999{
                DispatchQueue.main.async {
                    self.delegate?.restActionDidError()
                }
//                return
            }
            else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200{
                DispatchQueue.main.async {
                    print( "Response: \(httpResponse)" )
                    self.delegate?.restActionDidSuccessful(data: data! as Data, identifier: identifier)
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
    
    
}
