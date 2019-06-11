//
//  AyudaViewControlller.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class AyudaViewControlller: UIViewController {

    
    @IBOutlet weak var viewTour: UIView!
    @IBOutlet weak var tableView: UITableView!
    var toggle = false
    var selectedRow = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElements()
    }

    //MARK: - UIActions
    
    //MARK: - Helper methods
    func initUIElements(){
        viewTour.layer.cornerRadius = 10.0
    }
    
}

extension AyudaViewControlller: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "      PREGUNTAS FRECUENTES"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
        
        let font = UIFont(name: "Nunito-Black", size: 17)!
        header.textLabel?.font = font
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 35, height: 35))
        imageView.image = UIImage(named: "producto_detail_placeholder")
        header.addSubview(imageView)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreguntaCell", for: indexPath) as! PreguntaTableViewCell
        cell.lblPregunta.text = "Pregunta 1"
        
        if toggle{
            cell.txtRespuesta.text = "Para poder realizar una bonificación es necesario ir a la sección de bonificaciones"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        tableView.reloadRows(at: [indexPath], with: .fade)
        toggle = !toggle
        selectedRow = indexPath.row
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if toggle && selectedRow == indexPath.row{
            return 120
        }
        else{
            return 44
        }
    }
}
