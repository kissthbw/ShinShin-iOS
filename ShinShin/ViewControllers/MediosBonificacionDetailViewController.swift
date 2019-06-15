//
//  MediosBonificacionDetailViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/13/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol MediosBonificacionControllerDelegate: class{
//    func addItemViewController(_ controller: ItemDetailViewController,
//                               didFinishAdding item: ChecklistItem)
//    func addItemViewController(_ controller: ItemDetailViewController,
//                               didFinichEditing item: ChecklistItem)
    func addItemViewController(_ controller: MediosBonificacionDetailViewController, didFinishAddind item: String)
}

class MediosBonificacionDetailViewController: UITableViewController {

    var sectionSelected = -1
    weak var delegate: MediosBonificacionControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //MARK: - Helper Methods
    @objc func guardarItem(){
        delegate?.addItemViewController(self, didFinishAddind: "Item guardado")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sectionSelected == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BancoDetailCell", for: indexPath) as! BancoDetailTableViewCell
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            return cell
        }
        else if sectionSelected == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalDetailCell", for: indexPath) as! PayPalDetailTableViewCell
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaDetailCell", for: indexPath) as! RecargaDetailTableViewCell
            cell.btnGuardar.addTarget(self, action: #selector(guardarItem), for: .touchUpInside)
            return cell
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
