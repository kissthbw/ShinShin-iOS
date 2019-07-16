//
//  NotificacionesTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/16/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class NotificacionesTableViewController: UITableViewController {

    //MARK: - Propiedades
    var isMenuVisible = false
    var items: [Notificacion] = [Notificacion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        
        if Model.notificaciones.count > 0{
            print("Con notificaciones")
            items = Model.notificaciones
        }
        else{
            print("Con notificaciones dummy")
            let item = Notificacion()
            item.title = "Se agregaron $25 a tu cuenta"
            item.body = "dd/mm/aaaaa"
            item.fecha = "dd/mm/aaaaa"
            item.imagen = "agregar"
            items.append(item)
            
            let item2 = Notificacion()
            item2.title = "Solicitaste un retiro por $100 que se vera reflejado en tu cuenta ****2150"
            item.body = "dd/mm/aaaaa"
            item2.fecha = "dd/mm/aaaaa"
            item2.imagen = "retiro"
            items.append(item2)
            
            let item3 = Notificacion()
            item3.title = "Llegó Agua Bonafont 500 ml \n - Gana $5"
            item.body = "dd/mm/aaaaa"
            item3.fecha = "dd/mm/aaaaa"
            item3.imagen = "bonafont"
            items.append(item3)
        }
        
        configureBarButtons()
    }

    //Helper Methods
    func configureBarButtons(){
        let img = UIImage(named: "money-grey")
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 4, y: 6, width: 22, height: 22)
        
        let lblBonificacion = UILabel()
        lblBonificacion.font = UIFont(name: "Nunito SemiBold", size: 17)
        lblBonificacion.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        lblBonificacion.text = Validations.formatWith(Model.totalBonificacion)
        lblBonificacion.sizeToFit()
        let frame = lblBonificacion.frame
        lblBonificacion.frame = CGRect(x: 27, y: 6, width: frame.width, height: frame.height)
        
        //El tamanio del view debe ser
        //lblBonificacion.width + imageView.x + imageView.width + 4(que debe ser lo mismo que imageView.x
        let width = lblBonificacion.frame.width + imageView.frame.minX +
            imageView.frame.width + imageView.frame.minX
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 32))
        view.layer.cornerRadius = 10.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0).cgColor
        view.addSubview(imageView)
        view.addSubview(lblBonificacion)
        
        self.navigationItem.titleView = view
        
        let home = UIBarButtonItem(
            image: UIImage(named: "logo-menu"),
            style: .plain,
            target: self,
            action: #selector(showHome))
        home.tintColor = .black
        
        let notif = UIBarButtonItem(
            image: UIImage(named: "bar-notif-grey"),
            style: .plain,
            target: self,
            action: #selector(showNotif))
        notif.tintColor = .black
        
        let user = UIBarButtonItem(
            image: UIImage(named: "bar-user-grey"),
            style: .plain,
            target: self,
            action: #selector(showMenu))
        user.tintColor = .black
        navigationItem.rightBarButtonItems = [user, notif]
        navigationItem.leftBarButtonItems = [home]
    }
    
    @objc
    func showHome(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func showNotif(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showMenu(){
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0{
//            return "Hoy"
//        }
//        else{
//            return "Ayer"
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("NotificacionHeader", owner: nil, options: nil)!.first as! NotificationHeaderView
        
        if section == 0{
            header.lblTitulo.text = "HOY"
        }
        else if section == 1{
            header.lblTitulo.text = "AYER"
        }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificacionCell", for: indexPath) as! NotificacionesTableViewCell
        
        let item = items[indexPath.row]
        
        cell.lblTitulo.text = item.title
        cell.lblFecha.text = item.body
        
        if let imagen = item.imagen{
            cell.imageViewNotificacion.image = UIImage(named: imagen)
        }
        else{
            cell.imageViewNotificacion.image = UIImage(named: "agregar")
        }
        

        return cell
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
