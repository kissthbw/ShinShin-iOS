//
//  DatosTicketViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/3/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class DatosTicketViewController: UIViewController {

    @IBOutlet weak var lblTienda: UILabel!
    @IBOutlet weak var lblTicket: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var btnEnviar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUIElements()
    }
    
    //MARK: - UIActions
    
    //MARK: - Helper methods
    func initUIElements(){
        btnEnviar.layer.cornerRadius = 5.0
        lblTienda.layer.cornerRadius = 5.0
        lblTienda.layer.cornerRadius = 5.0
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

extension DatosTicketViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Productos"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath) as! ProductoTicketTableViewCell
        
        cell.lblProducto.text = "Paq. 2 aguas Bonafont"
        cell.lblContenido.text = "600 ml"
        cell.lblCantidad.text = "Cant: 1"
        cell.lblCodigoBarras.text = "123456789012"
        cell.lblBonificacion.text = "$ 5"
        
        
        return cell
    }
    
    
}
