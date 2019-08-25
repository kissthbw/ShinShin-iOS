//
//  ConfirmarEliminarViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 8/24/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ConfirmarEliminarViewController: UIViewController {

    
    @IBOutlet weak var btnConfirmar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnConfirmar.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - UIActions
    @IBAction func close(_ sender: Any) {
        //Mover hasta el home y cerrar
//        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
