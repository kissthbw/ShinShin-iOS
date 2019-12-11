//
//  ConfirmacionRecuperarViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 22/11/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ConfirmacionRecuperarViewController: UIViewController {

    @IBOutlet weak var btnVale: UIButton!
    @IBOutlet weak var btnCorreo: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnVale.layer.cornerRadius = 10.0
        btnCorreo.layer.cornerRadius = 10.0
    }
    

    //MARK: - UIActions
    @IBAction func valeActions(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
