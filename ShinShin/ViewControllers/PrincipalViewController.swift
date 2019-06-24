//
//  PrincipalViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class PrincipalViewController: UIViewController {

    @IBOutlet weak var viewBottomBanner: UIView!
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
        
        let menuNavigationController = storyboard!.instantiateViewController(withIdentifier: "MenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = menuNavigationController
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = CGFloat(300)
        
        viewBottomBanner.layer.cornerRadius = 15.0
        configureBarButtons()
        bannersRequest()
        favoritosRequest()
        catalogoTiendasRequest()
        catalogoDepartamentosRequest()
    }
    
    //MARK: - UIActions
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
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
            action: nil)
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
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//
//        if section == 1{
//            let header = view as! UITableViewHeaderFooterView
//            header.textLabel?.textColor = UIColor.darkGray
//            print("Table width: \(tableView.frame.width)")
//            let btnMas = UIButton(type: .system)
//            btnMas.frame = CGRect(x: tableView.frame.width - 100, y: 5, width: 100, height: 20)
//            btnMas.addTarget(self, action: #selector(btnMasAction(sender:)), for: .touchUpInside)
//            btnMas.setTitle("Ver todos", for: .normal)
//            header.addSubview(btnMas)
//        }
//    }
    
    @objc func btnMasAction(sender: UIButton!){
        performSegue(withIdentifier: "ProductosSegue", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let header = Bundle.main.loadNibNamed("HeaderBannerView", owner: nil, options: nil)!.first as! UIView
            
            return header
        }
        else if section == 1{
            let header = Bundle.main.loadNibNamed("HeaderPrincipal", owner: nil, options: nil)!.first as! HeaderPrincipalView
            
            header.lblNombreSeccion.text = categories[section]
            header.imageViewSeccion.image = UIImage(named: "populares-grey")
            header.btnAccion.isHidden = false
            header.btnAccion.setTitle("Ver todos", for: .normal)
            header.btnAccion.addTarget(self, action: #selector(btnMasAction(sender:)), for: .touchUpInside)
            return header
        }
        else if section == 2{
            let header = Bundle.main.loadNibNamed("HeaderPrincipal", owner: nil, options: nil)!.first as! HeaderPrincipalView
            
            header.lblNombreSeccion.text = categories[section]
            header.imageViewSeccion.image = UIImage(named: "departamentos-gray")
            header.btnAccion.isHidden = true
            return header
        }
        else {
            let header = Bundle.main.loadNibNamed("HeaderPrincipal", owner: nil, options: nil)!.first as! HeaderPrincipalView
            
            header.lblNombreSeccion.text = categories[section]
            header.imageViewSeccion.image = UIImage(named: "departamentos-gray")
            header.btnAccion.isHidden = false
            header.btnAccion.setTitle("Privacidad", for: .normal)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        else{
            return 44
        }
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
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
//        if isMenuVisible{
//            isMenuVisible = !isMenuVisible
////            let viewMenuBack : UIView = (self.navigationController?.view.subviews.last)!
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
//
//            menuVC.delegate = self
//            self.view.addSubview(menuVC.view)
//            self.addChild(menuVC)
//            menuVC.view.layoutIfNeeded()
////            menuVC.view.layer.shadowRadius = 2.0
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
