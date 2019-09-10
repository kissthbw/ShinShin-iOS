//
//  PrivacidadViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/28/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PrivacidadViewController: UIViewController {

    //MARK: - Propiedades
    enum Origen{
        case Inicio
        case Registro
        case Menu
    }
    
    var origen: Origen = .Inicio
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    //MARK:  - Actions
    @IBAction func back(_ sender: Any) {
        if origen == .Inicio || origen == .Menu{
            self.dismiss(animated: true, completion: nil)
        }
        else if origen == .Registro{
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
