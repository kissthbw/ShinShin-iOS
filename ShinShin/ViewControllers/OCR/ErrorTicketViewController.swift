//
//  ErrorTicketViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 8/1/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol ErrorTicketViewControllerDelegate: class{
    func didCompleted(_ controller: ErrorTicketViewController)
}

class ErrorTicketViewController: UIViewController {

    
    @IBOutlet weak var btnIntentar: UIButton!
    @IBOutlet weak var lblMensaje: UILabel!
    
    var mensaje: String?
    weak var delegate: ErrorTicketViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnIntentar.layer.cornerRadius = 10.0
        
        if let msg = mensaje{
            lblMensaje.text = msg
        }
    }
    
    @IBAction func close(_ sender: Any) {
        delegate?.didCompleted(self)
//        self.dismiss(animated: true, completion: nil)
//        let controllers = self.navigationController?.viewControllers
//        for vc in controllers! {
//            if vc is CustomCameraViewController {
//                _ = self.navigationController?.popToViewController(vc as! CustomCameraViewController, animated: true)
//            }
//        }
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
