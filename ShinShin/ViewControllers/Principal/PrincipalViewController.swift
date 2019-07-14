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

    //MARK: - Propiedades
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var tituloHeader: String = ""
    
    var categories = ["", "", "POPULARES", "DEPARTAMENTOS", "TIENDAS"]
    var isMenuVisible = false
    var catalogoDeptos: CatalogoDepartamentosArray = CatalogoDepartamentosArray()
    var catalogoTiendas: CatalogoTiendasArray = CatalogoTiendasArray()
    var favoritos: ProductoArray = ProductoArray()
    var banners: ProductoArray = ProductoArray()
    var isClosedFotoCell = false
    
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
        SideMenuManager.default.menuWidth = CGFloat(307)
        
//        viewBottomBanner.layer.cornerRadius = 15.0
        self.navigationController?.navigationBar.isTranslucent = false
        configureBarButtons()
        bannersRequest()
        favoritosRequest()
        catalogoTiendasRequest()
        catalogoDepartamentosRequest()
    }
    
    //MARK: - Actions
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func closeBanner(_ sender: Any) {
//        UIView.animate(withDuration: 2.0,
//                       delay: 0.0,
//                       usingSpringWithDamping: 0.5,
//                       initialSpringVelocity: 5.0,
//                       options: [.curveEaseIn],
//                       animations: {
//                        self.topConstraint.constant = 0
//                        self.view.setNeedsLayout()
//                        self.view.layoutIfNeeded()
//        }, completion: nil)
        isClosedFotoCell = true
        tableView.beginUpdates()
        tableView.endUpdates()
        
//        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
//
//            tableView.rowHeight = 88.0
//            cell.layoutIfNeeded()
//
//        }, completion: { finished in
//
//            print("Row heights changed!")
//        })
        
    }
    
    @IBAction func fotoAction(_ sender: Any) {
        performSegue(withIdentifier: "FotoSegue", sender: self)
    }
    
    
    //MARK: - Helper Methods
    func configureBarButtons(){
        let img = UIImage(named: "money-grey")
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 8, y: 6, width: 22, height: 22)
        
        let lblBonificacion = UILabel()
        lblBonificacion.font = UIFont(name: "Nunito SemiBold", size: 17)
        lblBonificacion.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        lblBonificacion.text = Validations.formatWith(Model.totalBonificacion)
        
        lblBonificacion.sizeToFit()
        let frame = lblBonificacion.frame
        lblBonificacion.frame = CGRect(x: 31, y: 6, width: frame.width, height: frame.height)
        
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
        let button = UIButton(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height))
        button.addTarget(self, action: #selector(showView), for: .touchUpInside)
        view.addSubview(button)
        
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
    
    @objc
    func showNotif(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showView(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "BonificacionViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showMenu(){
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetalleProducto"{
            let item = sender as! Producto
            let vc = segue.destination as! ProductoDetalleViewController
            vc.item = item
        }
        
        if segue.identifier == "ProductosSegue"{
            let vc = segue.destination as! ProductosTableViewController
            vc.tituloHeader = tituloHeader
            //tituloHeader
        }
    }

}

//MARK: - Extensions
extension PrincipalViewController: CollectionViewDelegate{
    func selectedItem(_ controller: UITableViewCell, item: Producto) {
        performSegue(withIdentifier: "DetalleProducto", sender: item)
    }
}

extension PrincipalViewController: DeptoTableViewDelegate{
    func selectedItem(_ controller: UITableViewCell, item: CatalogoDepartamentos) {
        tituloHeader = item.nombreTipoProducto ?? ""
        performSegue(withIdentifier: "ProductosSegue", sender: item)
    }
}

extension PrincipalViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            if isClosedFotoCell{
                return 0
            }
            else{
                return 200
            }
            
        }
        if indexPath.section == 1{
            return 150
        }
        else if indexPath.section == 2{
            return 210
        }
        else if indexPath.section == 3{
            return 82
        }
        else if indexPath.section == 4{
            return 164
        }
        else{
            return 44
        }
        
    }
    
    @objc func btnMasAction(sender: UIButton!){
        let btn = sender as UIButton
        tituloHeader = categories[btn.tag]
        
        performSegue(withIdentifier: "ProductosSegue", sender: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2{
            let header = Bundle.main.loadNibNamed("HeaderPrincipal", owner: nil, options: nil)!.first as! HeaderPrincipalView
            
            header.lblNombreSeccion.text = categories[section]
            header.imageViewSeccion.image = UIImage(named: "populares-grey")
            header.btnAccion.isHidden = false
            header.btnAccion.tag = section
            header.btnAccion.setTitle("Ver todos", for: .normal)
            header.btnAccion.addTarget(self, action: #selector(btnMasAction(sender:)), for: .touchUpInside)
            return header
        }
        else if section == 3{
            let header = Bundle.main.loadNibNamed("HeaderPrincipal", owner: nil, options: nil)!.first as! HeaderPrincipalView
            
            header.lblNombreSeccion.text = categories[section]
            header.imageViewSeccion.image = UIImage(named: "departamentos-gray")
            header.btnAccion.isHidden = true
            return header
        }
        else if section == 4{
            let header = Bundle.main.loadNibNamed("HeaderPrincipal", owner: nil, options: nil)!.first as! HeaderPrincipalView
            
            header.lblNombreSeccion.text = categories[section]
            header.imageViewSeccion.image = UIImage(named: "departamentos-gray")
            header.btnAccion.isHidden = false
            header.btnAccion.setTitle("Privacidad", for: .normal)
            return header
        }
        else{
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0 ))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1{
            
            return 0
        }
        else{
            return 44
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return categories[section]
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FotoCell", for: indexPath)
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriaCell") as! CategoriaTableViewCell
            cell.delegate = self
            cell.list = banners.productos
        
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularesCell", for: indexPath) as! PopularTableViewCell
            cell.delegate = self
            cell.list = favoritos.productos
            return cell
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepartamentosCell", for: indexPath) as! DeptoTableViewCell
            cell.delegate = self
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

//MARK: - RESTActionDelegate
extension PrincipalViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        do{
            let decoder = JSONDecoder()
            
            if identifier == ID_RQT_BANNERS{
                self.banners = try decoder.decode(ProductoArray.self, from: data)
                
                self.tableView.reloadSections(IndexSet(integersIn: 1...1), with: .automatic)
            }
            else if identifier == ID_RQT_FAVORITOS{
                self.favoritos = try decoder.decode(ProductoArray.self, from: data)
                
                self.tableView.reloadSections(IndexSet(integersIn: 2...2), with: .automatic)
            }
            else if identifier == ID_RQT_DEPTOS{
                self.catalogoDeptos = try decoder.decode(CatalogoDepartamentosArray.self, from: data)
                
                self.tableView.reloadSections(IndexSet(integersIn: 3...3), with: .automatic)
            }
            else if identifier == ID_RQT_TIENDAS{
                self.catalogoTiendas = try decoder.decode(CatalogoTiendasArray.self, from: data)
                
                self.tableView.reloadSections(IndexSet(integersIn: 4...4), with: .automatic)
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
