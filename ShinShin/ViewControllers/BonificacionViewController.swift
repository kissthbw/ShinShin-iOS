//
//  BonificacionViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BonificacionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    enum Proceso {
        case Historico
        case Retirar
    }
    
    var tipoProceso: Proceso = .Historico

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - UIActions
    @IBAction func showHistorialAction(_ sender: Any) {
        tipoProceso = .Historico
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .left)

//        tableView.reloadSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>)
//        tableView.reloadData()
    }
    
    @IBAction func showRetirarAction(_ sender: Any) {
        tipoProceso = .Retirar
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .right)
//        tableView.reloadData()
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

extension BonificacionViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tipoProceso == .Historico{
            return 60
        }
        else{
            return 88
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tipoProceso == .Historico{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoricoBonificacionCell", for: indexPath) as! HistoricoBonificacionTableViewCell
            
            cell.lblTipo.text = "Paq. móvil"
            cell.lblFecha.text = "03/06/2019"
            cell.lblCantidad.text = "$ 100.00"
            //        cell.imageView?.image = UIImage(named: "img_placeholder")
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BonificacionCell", for: indexPath) as! BonificacionTableViewCell
            cell.lblTitulo.text = "PayPal"
            return cell
        }
    }
    
    
}
