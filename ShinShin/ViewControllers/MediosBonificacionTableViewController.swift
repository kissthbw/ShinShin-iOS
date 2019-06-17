//
//  MediosBonificacionTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class MediosBonificacionTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var sectionSelected = -1
    var isMenuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtons()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Helper methods
    func configureBarButtons(){
        let notif = UIBarButtonItem(
            image: UIImage(named: "notif_placeholder"),
            style: .plain,
            target: self,
            action: #selector(showNotif))
        notif.tintColor = .black
        
        let user = UIBarButtonItem(
            image: UIImage(named: "user_placeholder"),
            style: .plain,
            target: self,
            action: #selector(showMenu))
        user.tintColor = .black
        navigationItem.rightBarButtonItems = [user, notif]
    }
    @objc func btnMasAction(sender: UIButton!){
        sectionSelected = sender.tag
        performSegue(withIdentifier: "BancariaSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MediosBonificacionDetailViewController
        vc.sectionSelected = sectionSelected
        vc.delegate = self
    }
   
}

extension MediosBonificacionTableViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0{
            return 44
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 60
        }
        else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section != 0{
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.lightGray
            let imageView = UIImageView(frame: CGRect(x: 5, y: 6, width: 35, height: 35))
            imageView.image = UIImage(named: "producto_detail_placeholder")
            header.addSubview(imageView)
            header.backgroundColor = .white
            
            let btnMas = UIButton(type: .system)
            btnMas.tag = section
            btnMas.frame = CGRect(x: tableView.frame.width - 100, y: 9, width: 100, height: 20)
            btnMas.addTarget(self, action: #selector(btnMasAction(sender:)), for: .touchUpInside)
            var title = ""
            if section == 0{
                title = "+ Tarjeta"
            }
            else if section == 1{
                title = "+ Cuenta"
            }
            else{
                title = "+ Número"
            }
            
            btnMas.setTitle(title, for: .normal)
            header.addSubview(btnMas)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "¿?"
        }
        else if section == 1{
            return "       Bancarias"
        }
        else if section == 2{
            return "       PayPal"
        }
        else {
            return "       Recargas telefónicas"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BancoCell", for: indexPath) as! BancoTableViewCell
            cell.lblCuenta.text = "2159****"
            cell.lblVigencia.text = "02/24"
            cell.lblTipo.text = "Visa"
            
            
            return cell
        }
        else if indexPath.section == 2{
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
}

extension MediosBonificacionTableViewController: MediosBonificacionControllerDelegate{
    
    func addItemViewController(_ controller: MediosBonificacionDetailViewController, didFinishAddind item: String) {
        
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.topConstraint.constant = 120
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
        }, completion: { (true) in
            UIView.animate(withDuration: 2.0,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 5.0,
                           options: [.curveEaseIn],
                           animations: {
                            self.topConstraint.constant = 0
                            self.view.setNeedsLayout()
                            self.view.layoutIfNeeded()
            }, completion: nil)
        })
        
        
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
}

extension MediosBonificacionTableViewController: SideMenuDelegate{
    
    @objc
    func showNotif(){
        openViewControllerBasedOnIdentifier("NotificacionesTableViewController")
    }
    
    @objc
    func showMenu(){
        
        if isMenuVisible{
            isMenuVisible = !isMenuVisible
            let viewMenuBack : UIView = view.subviews.last!
            
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
        else{
            isMenuVisible = !isMenuVisible
            let menuVC : SideMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewControllerOK") as! SideMenuViewController
            //        menuVC.btnMenu = sender
            menuVC.delegate = self
            self.view.addSubview(menuVC.view)
            self.addChild(menuVC)
            menuVC.view.layoutIfNeeded()
            menuVC.view.layer.shadowRadius = 2.0
            
            
            menuVC.view.frame=CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                menuVC.view.frame=CGRect(x: 100, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                //            sender.isEnabled = true
            }, completion:nil)
        }
        
        
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
