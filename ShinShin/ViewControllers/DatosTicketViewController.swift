//
//  DatosTicketViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/3/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class DatosTicketViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var isMenuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtons()
        
        let menuNavigationController = storyboard!.instantiateViewController(withIdentifier: "MenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = menuNavigationController
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = CGFloat(300)
    }
    
    //MARK: - UIActions
    
    //MARK: - Helper methods
    //Helper Methods
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
    
    @objc
    func enviarTicket(){
        performSegue(withIdentifier: "EnviarTicketSegue", sender: self)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2{
            return "Productos"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 160
        case 2:
            return 70
        case 3:
            return 160
        default:
            return 44
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 20
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MensajeCell", for: indexPath)
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTicketTableViewCell
            
            return cell
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as! TotalTicketTableViewCell
            cell.btnEnviar.addTarget(self, action: #selector(enviarTicket), for: .touchUpInside)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath) as! ProductoTicketTableViewCell
            
            cell.lblNombre.text = "Paq. 2 aguas Bonafont"
            cell.lblPresentacion.text = "600 ml"
            cell.lblCantidad.text = "Cant: 1"
            cell.lblCodigo.text = "123456789012"
            cell.lblBonificacion.text = "$ 5"
            
            
            return cell
        }
    }
    
    
}

extension DatosTicketViewController: SideMenuDelegate{
    
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
    func showNotif(){
        openViewControllerBasedOnIdentifier("NotificacionesTableViewController")
    }
    
    @objc
    func showHome(){
        self.navigationController?.popToRootViewController(animated: true)
//        self.navigationController?.popViewController(animated: true)
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
