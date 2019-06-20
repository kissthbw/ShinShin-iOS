//
//  PrincipalViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PrincipalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var categories = ["", "POPULARES", "DEPARTAMENTOS", "TIENDAS"]
    var isMenuVisible = false
    
    var catalogoDeptos: CatalogoDepartamentosArray = CatalogoDepartamentosArray()
    var catalogoTiendas: CatalogoTiendasArray = CatalogoTiendasArray()
    var favoritos: ProductoArray = ProductoArray()
    var banners: ProductoArray = ProductoArray()
    
    
    let ID_RQT_BANNERS = "ID_RQT_BANNERS"
    let ID_RQT_FAVORITOS = "ID_RQT_FAVORITOS"
    let ID_RQT_DEPTOS = "ID_RQT_DEPTOS"
    let ID_RQT_TIENDAS = "ID_RQT_TIENDAS"
    enum Seccion{
        case Banners
        case Favoritos
        case Departamentos
        case Tiendas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBarButtons()
        bannersRequest()
        favoritosRequest()
        catalogoTiendasRequest()
        catalogoDepartamentosRequest()
    }
    

    //MARK: - UIActions
    @IBAction func closeBanner(_ sender: Any) {
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
    }
    
    @IBAction func fotoAction(_ sender: Any) {
        performSegue(withIdentifier: "FotoSegue", sender: self)
    }
    
    
    //Helper Methods
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
    
    func bannersRequest(){
        do{
            RESTHandler.delegate = self
            RESTHandler.getOperationTo(RESTHandler.obtieneBanners, and: ID_RQT_BANNERS)
        }
        catch{
            
        }
    }
    
    func favoritosRequest(){
        do{
            RESTHandler.delegate = self
            RESTHandler.getOperationTo(RESTHandler.obtieneProductos, and: ID_RQT_FAVORITOS)
        }
        catch{
            
        }
    }
    
    func catalogoDepartamentosRequest(){
        do{
            RESTHandler.delegate = self
            RESTHandler.getOperationTo(RESTHandler.obtieneCatalogoDepartamentos, and: ID_RQT_DEPTOS)
        }
        catch{
            
        }
    }
    
    func catalogoTiendasRequest(){
        do{
            RESTHandler.delegate = self
            RESTHandler.getOperationTo(RESTHandler.obtieneCatalogoTiendas, and: ID_RQT_TIENDAS)
        }
        catch{
            
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetalleProducto"{
            let item = sender as! Producto
            let vc = segue.destination as! ProductoDetalleViewController
            vc.item = item
        }
    }

}

extension PrincipalViewController: CollectionViewDelegate{
    func selectedItem(_ controller: UITableViewCell, item: Producto) {
        performSegue(withIdentifier: "DetalleProducto", sender: item)
    }
    
    
}

extension PrincipalViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 150
        }
        else if indexPath.section == 1{
            return 210
        }
        else if indexPath.section == 2{
            return 82
        }
        else if indexPath.section == 3{
            return 164
        }
        else{
            return 44
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section == 1{
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.darkGray
            print("Table width: \(tableView.frame.width)")
            let btnMas = UIButton(type: .system)
            btnMas.frame = CGRect(x: tableView.frame.width - 100, y: 5, width: 100, height: 20)
            btnMas.addTarget(self, action: #selector(btnMasAction(sender:)), for: .touchUpInside)
            btnMas.setTitle("Ver todos", for: .normal)
            header.addSubview(btnMas)
        }
    }
    
    @objc func btnMasAction(sender: UIButton!){
        performSegue(withIdentifier: "ProductosSegue", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriaCell") as! CategoriaTableViewCell
            cell.delegate = self
            cell.list = banners.productos
        
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularesCell", for: indexPath) as! PopularTableViewCell
            cell.delegate = self
            cell.list = favoritos.productos
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepartamentosCell", for: indexPath) as! DeptoTableViewCell
            cell.list = catalogoDeptos.tipoProductos
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TiendasCell", for: indexPath) as! TiendaTableViewCell
            cell.list = catalogoTiendas.tiendas
            return cell
        }
        
    }
    
    
}

extension PrincipalViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(identifier)" )
        
        do{
            let decoder = JSONDecoder()
            
            if identifier == ID_RQT_BANNERS{
                banners = try decoder.decode(ProductoArray.self, from: data)
                
                tableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
            }
            else if identifier == ID_RQT_FAVORITOS{
                favoritos = try decoder.decode(ProductoArray.self, from: data)
                
                tableView.reloadSections(IndexSet(integersIn: 1...1), with: .automatic)
            }
            else if identifier == ID_RQT_DEPTOS{
                catalogoDeptos = try decoder.decode(CatalogoDepartamentosArray.self, from: data)
                
                tableView.reloadSections(IndexSet(integersIn: 2...2), with: .automatic)
            }
            else if identifier == ID_RQT_TIENDAS{
                catalogoTiendas = try decoder.decode(CatalogoTiendasArray.self, from: data)
                
                tableView.reloadSections(IndexSet(integersIn: 3...3), with: .automatic)
            }
            
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

extension PrincipalViewController: SideMenuDelegate{
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
    func showMenu(){
        
        if isMenuVisible{
            isMenuVisible = !isMenuVisible
//            let viewMenuBack : UIView = (self.navigationController?.view.subviews.last)!
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

            menuVC.delegate = self
            self.view.addSubview(menuVC.view)
            self.addChild(menuVC)
            menuVC.view.layoutIfNeeded()
//            menuVC.view.layer.shadowRadius = 2.0
            
            
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
        
        let vcs = self.navigationController!.viewControllers
        for vc in vcs {
            print("ID: \(vc)")
        }
        
        
        let topViewController = self.navigationController!.topViewController!
        print("ID: \(topViewController)")
        
//
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
}
