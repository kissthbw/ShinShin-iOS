//
//  AyudaViewControlller.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class AyudaViewControlller: UIViewController {

    @IBOutlet weak var btnTour: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var toggle = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElements()
    }

    //MARK: - UIActions
    
    //MARK: - Helper methods
    func initUIElements(){
        btnTour.layer.cornerRadius = 5.0
    }
    
}

extension AyudaViewControlller: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Preguntas frecuentes"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreguntaCell", for: indexPath) as! PreguntaTableViewCell
        cell.lblPregunta.text = "Pregunta 1"
        
        if toggle{
            cell.txtRespuesta.text = "Para poder realizar una bonificación es necesario ir a la sección de bonificaciones"
        }
        
//        cell.textLabel?.text = "Pregunta 1"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        tableView.reloadRows(at: [indexPath], with: .fade)
        toggle = !toggle
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if toggle{
            return 120
        }
        else{
            return 44
        }
    }
}
