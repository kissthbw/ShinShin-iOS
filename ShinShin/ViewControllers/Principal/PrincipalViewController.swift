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
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var tituloHeader: String = ""
    
    var categories = ["", "", "Populares", "Departamentos", "Tiendas"]
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
    let ID_RQT_SUGERENCIA = "ID_RQT_SUGERENCIA"
    
    var tmpCell: QueProductosTableViewCell?
    
    enum Seccion{
        case Banners
        case Favoritos
        case Departamentos
        case Tiendas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Si es primera vez, mostrar intro
        if Model.isFirtsTime(){
            let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "IntroViewController")
            destViewController.modalPresentationStyle = .fullScreen
            destViewController.modalTransitionStyle = .coverVertical
            
            Model.handleFirstTime()
            
            self.present(destViewController, animated: true, completion: nil)
        }
        
        cardView.layer.cornerRadius = 10.0
        
        let menuNavigationController = storyboard!.instantiateViewController(withIdentifier: "MenuNavigationController") as! SideMenuNavigationController
        SideMenuManager.default.rightMenuNavigationController = menuNavigationController
        
        var presentationStyle = SideMenuPresentationStyle()
        presentationStyle = .menuSlideIn
        presentationStyle.backgroundColor = .black
//        presentationStyle.menuStartAlpha = 1.0
        presentationStyle.onTopShadowOpacity = 1 //Agrega un blur al menu
        presentationStyle.presentingEndAlpha = 0.4
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = CGFloat(307)
        settings.statusBarEndAlpha = 0.0
        settings.allowPushOfSameClassTwice = false
        
        menuNavigationController.settings = settings
        
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
//        self.navigationController?.navigationBar.shadowImage = nil
//        self.navigationController?.navigationBar.layoutIfNeeded()
        
        configureBarButtons()
        bannersRequest()
        favoritosRequest()
        catalogoTiendasRequest()
        catalogoDepartamentosRequest()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Model.perfilActualizado{
            Model.perfilActualizado = false
            lblMensaje.text = "De lujo, perfil guardado"
            mostrarMensaje()
        }
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    func mostrarMensaje(){
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.topConstraint.constant = 50
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

    }
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
            image: UIImage(named: "notification-grey"),
            style: .plain,
            target: self,
            action: #selector(showNotif))
        notif.tintColor = .black
        
        let user = UIBarButtonItem(
            image: UIImage(named: "menu-grey"),
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
        present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
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
    
    @objc func enviaSugerencia(){
        if let cell = tmpCell {
            let resp = cell.isValid()
            if resp.valid{
                //Validaciones
                self.tableView.endEditing(true);
                sugerenciaRequest(sugerencia: cell.txtProductos.text!)
            }
            else{
                present(resp.alert!, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func sugerenciaRequest(sugerencia: String){
        do{
            RESTHandler.delegate = self
            let item = Producto()
            item.idUsuario = Model.user?.idUsuario
            item.nombreProducto = sugerencia
            
            let encoder = JSONEncoder()
            let json = try encoder.encode(item)
            
            RESTHandler.postOperationTo(RESTHandler.sugerenciaProducto, with: json, and: ID_RQT_SUGERENCIA)
        }
        catch{
            print("Error al enviar sugerencia")
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
            return 160
        }
        else if indexPath.section == 2{
            return 210
        }
        else if indexPath.section == 3{
            return 90
        }
        else if indexPath.section == 4{
            return 500
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
            header.imageViewSeccion.image = UIImage(named: "market-grey")
            header.btnAccion.isHidden = false
            header.btnAccion.setTitle("Privacidad", for: .normal)
            return header
        }
        else{
            return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0 ))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 || section == 4{
            
            return 0
        }
        else{
            return 88
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueProductosCell", for: indexPath) as! QueProductosTableViewCell
            tmpCell = cell
            cell.txtProductos.delegate = self
            cell.btnEnviar.addTarget(self, action: #selector(enviaSugerencia), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    
}

extension PrincipalViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.showError(false, superView: true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
            else if identifier == ID_RQT_SUGERENCIA{
                //Enviar mensaje de exito, limpiar textfield y ocultar teclado
//                let alert = Validations.show(message: "Gracias por enviarnos tu sugerencia", with: "ShingShing")
                lblMensaje.text = "Gracias por tu sugerencia"
                tmpCell?.txtProductos.text = ""
                self.tableView.endEditing(true)
                mostrarMensaje()
//                present(alert, animated: true, completion: nil)
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
