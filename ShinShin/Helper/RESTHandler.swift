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
    //Local
//    static let server = "http://localhost:8080/shin-back"
    //AWS
    static let server = "http://shinshin-env.m7izq9trpe.us-east-2.elasticbeanstalk.com"
    
    //Usuario
    static let registrarSocialUsuario = server + "/usuarios/social/registrar"
    static let registrarUsuario = server + "/usuarios/usuario/registrar"
    static let activarUsuario = server + "/usuarios/usuario/activar"
    static let actualizarUsuario = server + "/usuarios/usuario/actualizar"
    static let eliminarUsuario = server + "/usuarios/usuario/eliminar"
    static let reenviarCodigo = server + "/usuarios/usuario/reenviar"
    static let login = server + "/usuarios/usuario/login"
    static let login2 = server + "/usuarios/usuario/login2"
    static let contacto = server + "/usuarios/contacto"
    static let restaurarPassword = server + "/usuarios/solicitarRestaurarPassword"

    //Pantalla principal
    static let obtieneProductos = server + "/productos/list"
    static let obtieneBanners = server + "/productos/listBanner"
    static let obtieneProductosPorTipo = server + "/productos/producto/porTipo"
    static let obtieneCatalogoDepartamentos = server + "/catalogoTipoProductos/list"
    static let obtieneCatalogoTiendas = server + "/catalogoTiendas/list"
    static let sugerenciaProducto = server + "/productos/sugerencias"
    
    //Pantalla de registrar ticket
//    static let registrarTicket = server + "/tickets/ticket/registrar"
    static let registrarTicket = server + "/usuarios/usuario/registrar/ticket"
    
    //Pantalla de medios de bonificacion
    static let obtieneCatalogoMediosBonificacion = server + "/catalogoMediosBonificacion/list"
    static let guardarMedioBonificacionUsuario = server + "/mediosBonificacion/mediosBonificacion/guardar"
    static let actualizarMedioBonificacionUsuario = server + "/mediosBonificacion//mediosBonificacion/actualizar"
    static let eliminarMedioBonificacionUsuario = server + "/mediosBonificacion/mediosBonificacion/eliminar"
    
    
    //Pantalla de retiros
    static let guardarBonificacion = server + "/historicoMediosBonificacion/historicoMediosBonificacion/registrar"
    
    static let obtieneHistoricoTickets = server + "/usuarios/usuario/historicoTickets"
    
    static let detalleTicket = server + "/tickets/detalle/"
    
    static let obtieneHistoricoBonificaciones = server + "/usuarios/usuario/historicoBonificaciones"
    
    static let obtieneInformacionBonificacion = server + "/usuarios/usuario/totalBonificacion"
    static let obtieneMediosBonificacionPorUsuario = server + "/usuarios/usuario/mediosBonificacion"
    
    static let obtieneTiposBancarias = server + "/catalogoMediosBonificacion/listTiposBancarias"
    
    //Pantalla de Ticket
    static let analizarOCR = server + "/tickets/analizar2"
    
    //Productos
    //http://shinshin-env.m7izq9trpe.us-east-2.elasticbeanstalk.com
//    static let obtieneProductos = "http://shinshin-env.m7izq9trpe.us-east-2.elasticbeanstalk.com/productos/list"

    
    class func getOperationTo(_ urlString: String, and identifier: String){
        
        let url = URL(string: urlString)
        print("Get operation to URI: \(url!)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request){ (data, response, error) in
            if let error = error as NSError?, error.code == -999{
//                print( "Error: \(error)" )
                DispatchQueue.main.async {
                    self.delegate?.restActionDidError()
                }
//                return
            }
            else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200{
                DispatchQueue.main.async {
//                    print( "Response: \(httpResponse)" )
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
        
//        print("Post operation to URI: \(url!)")
//        let json = try? JSONSerialization.jsonObject(with: data, options: [])
//        print("JSON: \(json)")
        
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
//                    print( "Response: \(httpResponse)" )
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
