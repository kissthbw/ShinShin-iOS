//
//  VerificacionViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 8/21/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol DismissViewControllerDelegate: class{
    func didBackViewController()
}

class VerificacionViewController: UIViewController {

    //MARK: - Propiedades
    @IBOutlet weak var btnEmpezar: UIButton!
    
    weak var delegate: DismissViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @IBAction func startAction(_ sender: Any) {
        self.delegate?.didBackViewController()
    }
    

}
