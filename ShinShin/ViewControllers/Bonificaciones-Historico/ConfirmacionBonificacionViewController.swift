//
//  ConfirmacionBonificacionViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ConfirmacionBonificacionViewController: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var btnAceptar: UIButton!
    
    var tipoRetiro: TipoRetiro = .Bancario
    let mensajeHeaderBancoPayPal = "Recibimos \n tu $olicitud"
    let mensajeHeaderRecarga = "¡Recarga \n enviada!"
    
    let mensajeBancoPayPal = "En las próximas 24 hrs. verás reflejado el deposito en la cuenta que nos indicaste."
    let mensajeRecarga = "Recibirás un SMS de confirmación en el teléfono que nos indicaste"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnAceptar.layer.cornerRadius = 10.0
        
        if tipoRetiro == .Bancario || tipoRetiro == .PayPal{
            lblHeader.text = mensajeHeaderBancoPayPal
            lblMensaje.text = mensajeBancoPayPal
        }
        else{
            lblHeader.text = mensajeHeaderRecarga
            lblMensaje.text = mensajeRecarga
        }
    }
    
    //MARK: - Actions
    @IBAction func cerrarAction(_ sender: Any) {
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
