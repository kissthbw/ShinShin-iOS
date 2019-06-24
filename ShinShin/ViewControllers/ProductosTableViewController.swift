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
import SideMenu

class ProductosTableViewController: UITableViewController {

    var productos: ProductoArray = ProductoArray()
    var isMenuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuNavigationController = storyboard!.instantiateViewController(withIdentifier: "MenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = menuNavigationController
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = CGFloat(300)
        
        configureBarButtons()
        productosRequest()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //MARK: - Helper methods
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
    
    func productosRequest(){
        do{
            RESTHandler.delegate = self
            RESTHandler.getOperationTo(RESTHandler.obtieneProductos, and: "")
        }
        catch{
            
        }
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
        return productos.productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCell", for: indexPath) as! ProductoTableViewCell
        
        let item = productos.productos[indexPath.row]

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
        vc.item = productos.productos[btn.tag]
    }
    
    //MARK: - UIActions
    
    
}

extension ProductosTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            let decoder = JSONDecoder()
            
            productos = try decoder.decode(ProductoArray.self, from: data)
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

extension ProductosTableViewController: SideMenuDelegate{
    
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
//        
        
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
