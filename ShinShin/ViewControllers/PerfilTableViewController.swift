//
//  PerfilTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/15/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class PerfilTableViewController: UITableViewController {

    @IBOutlet weak var imageViewPerfil: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtCumple: UITextField!
    @IBOutlet weak var txtCP: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    var isMenuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textfields = [txtNombre, txtCorreo,
                          txtTelefono, txtCumple, txtCP]
        
        txtNombre.delegate = self
        txtCorreo.delegate = self
        txtTelefono.delegate = self
        txtCumple.delegate = self
        txtCP.delegate = self
        
        let menuNavigationController = storyboard!.instantiateViewController(withIdentifier: "MenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = menuNavigationController
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = CGFloat(300)
        
        initUIElements(textfields)
        configureBarButtons()
    }

    //MARK: - Helper methods
    func initUIElements(_ elements: [UITextField?]){
        
        for text in elements {
            if let t = text{
                t.layer.borderWidth = 0.0
                t.layer.cornerRadius = 10.0
                t.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
            }
        }
        
        btnGuardar.layer.cornerRadius = 10.0
        //        btnActivar.layer.cornerRadius = 5.0
    }
    
    func configureBarButtons(){
        let img = UIImage(named: "money-grey")
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 4, y: 6, width: 22, height: 22)
        
        let lblBonificacion = UILabel()
        lblBonificacion.font = UIFont(name: "Nunito SemiBold", size: 17)
        lblBonificacion.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        lblBonificacion.text = "$ 10.00"
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
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

extension PerfilTableViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PerfilTableViewController: SideMenuDelegate{
    
    func closeMenu() {
        isMenuVisible = !isMenuVisible
        let viewMenuBack : UIView = (self.navigationController?.view.subviews.last)!
        //            let viewMenuBack : UIView = view.subviews.last!
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = UIScreen.main.bounds.size.width
            viewMenuBack.frame = frameMenu
            viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            viewMenuBack.removeFromSuperview()
        })
    }
    @objc
    func showHome(){
        self.navigationController?.popToRootViewController(animated: true)
        //        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func showNotif(){
        openViewControllerBasedOnIdentifier("NotificacionesTableViewController")
    }
    
    @objc
    func showMenu(){
        
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        
//        if isMenuVisible{
//            isMenuVisible = !isMenuVisible
//            let viewMenuBack : UIView = view.subviews.last!
//            
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                var frameMenu : CGRect = viewMenuBack.frame
//                frameMenu.origin.x = UIScreen.main.bounds.size.width
//                viewMenuBack.frame = frameMenu
//                viewMenuBack.layoutIfNeeded()
//                viewMenuBack.backgroundColor = UIColor.clear
//            }, completion: { (finished) -> Void in
//                viewMenuBack.removeFromSuperview()
//            })
//        }
//        else{
//            isMenuVisible = !isMenuVisible
//            let menuVC : SideMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewControllerOK") as! SideMenuViewController
//            //        menuVC.btnMenu = sender
//            menuVC.delegate = self
//            self.view.addSubview(menuVC.view)
//            self.addChild(menuVC)
//            menuVC.view.layoutIfNeeded()
//            menuVC.view.layer.shadowRadius = 2.0
//            
//            
//            menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//            
//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                menuVC.view.frame=CGRect(x: 100, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
//                //            sender.isEnabled = true
//            }, completion:nil)
//        }
        
        
    }
    
    func sideMenuItemSelectedAtIndex(_ index: Int) {
        isMenuVisible = !isMenuVisible
        
        switch(index){
        case 1:
            self.openViewControllerBasedOnIdentifier("PerfilTableViewController")
            break
        case 2: self.openViewControllerBasedOnIdentifier("MediosBonificacionTableViewController")
        case 3:
            self.openViewControllerBasedOnIdentifier("AyudaViewControlller")
        case 4:
            self.openViewControllerBasedOnIdentifier("ContactoViewController")
            break
        case 5:
            self.openViewControllerBasedOnIdentifier("BonificacionViewController")
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
}
