//
//  LogInViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 3/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

/*
 La funcionalidad general de esta clase es:
 Consumo del servicio de validación de usuario
 Consumo del servicio de log in via facebook
 Validación de obligatoriedad
 Permitir el registro de nuevos usuarios
 */

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UI Actions
    @IBAction func logIn(_ sender: Any) {
    }
    
    @IBAction func restAction(){
//        let rest = RESTHelper()
//        rest.delegate = self
//        rest.getOperationWith(urlString: RESTHelper.obtieneProductos)
        activity.startAnimating()
        RESTHandler.delegate = self
//        RESTHelper.getOperationWith(urlString: RESTHelper.usuariosList)
        let item = Usuario()
        item.idUsuario = 2
        item.nombre = "Adrian"
        item.apPaterno = "Osorio"
        item.apMaterno = "Alvarez"
        item.fechaNac = "1981-10-02"
        item.usuario = "adrian"
        item.contrasenia = "adrian"
        item.calle = "Pataguas"
        item.numeroExt = "115"
        item.numeroInt = ""
        item.colonia = "La Perla"
        item.codigoPostal = "57820"
        item.delMun = "Nezahualcoyotl"
        item.estado = "Estado de México"
        item.telLocal = "5557423747"
        
        do{
            let encoder = JSONEncoder()
            let json = try encoder.encode(item)
            RESTHandler.postOperationTo(RESTHandler.registraUsuario, with: json)
            print(json)
        }
        catch{
            print("JSON Error: \(error)")
        }
    }

}

extension LogInViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            let decoder = JSONDecoder()
            
            let result = try decoder.decode([Usuario].self, from: data)
            print(result)
        }
        catch{
            print("JSON Error: \(error)")
        }
        
        self.activity.stopAnimating()
        
    }
    
    func restActionDidError() {
        print( "restActionDidError" )
        self.activity.stopAnimating()
    }
    
    
}
