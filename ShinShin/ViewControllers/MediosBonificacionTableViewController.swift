//
//  MediosBonificacionTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class MediosBonificacionTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
////        headerView.alpha = 0.1
//        let imageViewGame = UIImageView(frame: CGRect(x: 5, y: 8, width: 40, height: 40));
//
////        let image = UIImage(named: "producto_detail_placeholder");
////        imageViewGame.image = image;
//
//        return headerView
//    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
        let imageView = UIImageView(frame: CGRect(x: 5, y: 6, width: 35, height: 35))
        imageView.image = UIImage(named: "producto_detail_placeholder")
//        header.contentMode = .bottomLeft
        header.addSubview(imageView)
//        header.
//        let headerImage = UIImage(named: "producto_detail_placeholder")
//        let headerImageView = UIImageView(image: headerImage)
//        header.backgroundView = headerImageView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "       Bancarias"
        }
        else if section == 1{
            return "       PayPal"
        }
        else{
            return "       Recargas telefónicas"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BancoCell", for: indexPath) as! BancoTableViewCell
            cell.lblCuenta.text = "2159****"
            cell.lblVigencia.text = "02/24"
            cell.lblTipo.text = "Visa"
            
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalCell", for: indexPath) as! PayPalTableViewCell
            cell.lblCuenta.text = "kissthbw@gmail.com"
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaCell", for: indexPath) as! RecargaTableViewCell
            cell.lblNumero.text = "55 5742 3747"
            cell.lblCompania.text = "Telcel"
            
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
