//
//  ProductosTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 3/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

/*
 La funcionalidad general de este clase es:
 Consultar productos por filtros(considerar el paginado cada que se scrolee)
 Poder ver el detalle del producto participante
 Calificar el producto (Se permisiste esta calificacion en local y en back)
 Agregar el producto a favoritos (Se permisiste esta calificacion en local y en back)
 */

import UIKit

class ProductosTableViewController: UITableViewController {

    var productos = [Producto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        productosRequest()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Populares"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath) as! ProductoTableViewCell
        
        let item = productos[indexPath.row]

        cell.lblNombre.text = item.nombreProducto
        cell.lblContenido.text = item.contenido
        cell.btnMasInfo.tag = indexPath.row
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let tmp = NSNumber(value: item.cantidadBonificacion!)
        if let bon = formatter.string(from: tmp){
            cell.lblBonificacion.text = "$ \(bon)"
        }
        
        
        
        return cell
    }

//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.deselectRow(at: indexPath, animated: true)
//        return nil
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deshabilita la seleccion de la celda
        tableView.deselectRow(at: indexPath, animated: true)

//        performSegue(withIdentifier: "ProductoDetalleSegue", sender: indexPath)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let indexPath = sender as! IndexPath
        let btn = sender as! UIButton
        let vc = segue.destination as! ProductoDetalleViewController
        vc.item = productos[btn.tag]
    }
    
    //MARK: - UIActions
    
    //MARK: - Helper methods
    func productosRequest(){
        do{
            RESTHandler.delegate = self
            RESTHandler.getOperationTo(RESTHandler.obtieneProductos, and: "")
        }
        catch{
            
        }
    }
}

extension ProductosTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            let decoder = JSONDecoder()
            
            productos = try decoder.decode([Producto].self, from: data)
            print(productos)
            tableView.reloadData()
        }
        catch{
            print("JSON Error: \(error)")
        }
    }
    
    func restActionDidError() {
        self.showNetworkError()
    }
    
    func showNetworkError(){
        let alert = UIAlertController(
            title: "Whoops...",
            message: "Ocurrió un problema." +
            " Favor de interntar nuevamente",
            preferredStyle: .alert)
        
        let action =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
