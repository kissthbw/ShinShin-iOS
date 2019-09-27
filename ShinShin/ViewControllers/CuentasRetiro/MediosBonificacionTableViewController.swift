//
//  MediosBonificacionTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class MediosBonificacionTableViewController: UIViewController {
    
    //MARK: - Propiedades
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblMensaje: UILabel!
    
    var medios: MediosBonificacionRSP = MediosBonificacionRSP()
    let ID_RQT_CATALOGO = "CATALOGO"
    let ID_RQT_MEDIOS = "MEDIOS"
    var sectionSelected = -1
    var isMenuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isTranslucent = false
        cardView.layer.cornerRadius = 10.0
        configureBarButtons()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        catalogoMediosRequest()
    }
    
    //MARK: - Helper methods
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
            action: #selector(showHome))
        home.tintColor = .black
        
        let notif = UIBarButtonItem(
            image: UIImage(named: "bar-notif-grey"),
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
    func showHome(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func showView(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "BonificacionViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showNotif(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showMenu(){
        present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
    }
    
    @objc func btnMasAction(sender: UIButton!){
        sectionSelected = sender.tag
        performSegue(withIdentifier: "BancariaSegue", sender: nil)
    }
    
    func catalogoMediosRequest(){
        do{
//            RESTHandler.delegate = self
//            RESTHandler.getOperationTo(RESTHandler.obtieneMediosBonificacionPorUsuario, and: ID_RQT_CATALOGO)
            let encoder = JSONEncoder()
            let user = Usuario()
            user.idUsuario = Model.user?.idUsuario
            let json = try encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.obtieneMediosBonificacionPorUsuario, with: json, and: ID_RQT_CATALOGO)
        }
        catch{
            
        }
    }
    
    func mediosBonificacionPorUsuario(){
        do{
            RESTHandler.delegate = self
            RESTHandler.getOperationTo(RESTHandler.obtieneCatalogoMediosBonificacion, and: ID_RQT_CATALOGO)
        }
        catch{
            
        }
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "BancariaSegue"{
            let vc = segue.destination as! MediosBonificacionDetailViewController
            vc.sectionSelected = sectionSelected
            vc.delegate = self
        }
        
        if segue.identifier == "EditBancariaSegue"{
            let vc = segue.destination as! MediosBonificacionDetailViewController
            let item = sender as! MediosBonificacion
            vc.sectionSelected = sectionSelected
            vc.delegate = self
            vc.item = item
        }
        
    }
   
}

//MARK: - Extensions
extension MediosBonificacionTableViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0{
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 60
        }
        else{
            return 47
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("MediosPagoView", owner: nil, options: nil)!.first as! MediosPagoView
        header.lblMedioBonificacion.text = medios.mediosBonificacion?[section - 1].nombreMedioBonificacion
        
        if section == 1{
            header.btnAccion.tag = section
            header.imageViewLogo.image = UIImage(named: "bank-grey")
            header.btnAccion.setTitle("+ Cuenta", for: .normal)
        }
        else if section == 2{
            header.btnAccion.tag = section
            header.imageViewLogo.image = UIImage(named: "paypal-grey")
            header.btnAccion.setTitle("+ Cuenta", for: .normal)
        }
        else if section == 3{
            header.btnAccion.tag = section
            header.imageViewLogo.image = UIImage(named: "recarga-grey")
            header.btnAccion.setTitle("+ Número", for: .normal)
        }
        
        
        header.btnAccion.addTarget(self, action: #selector(btnMasAction(sender:)), for: .touchUpInside)
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 0{
            return medios.mediosBonificacion?[section - 1].list?.count ?? 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: true)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sectionSelected = indexPath.section
        tableView.deselectRow(at: indexPath, animated: true)
        let item = medios.mediosBonificacion?[indexPath.section - 1].list?[indexPath.row]
        
        performSegue(withIdentifier: "EditBancariaSegue", sender: item)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            
            return cell
        }
        else if indexPath.section == 1{

            let item = medios.mediosBonificacion?[indexPath.section - 1].list?[indexPath.row]
            
            return configureCell(atIndexPath: indexPath, withItem: item)
            
        }
        else if indexPath.section == 2{
            
            let item = medios.mediosBonificacion?[indexPath.section - 1].list?[indexPath.row]
            
            return configureCell(atIndexPath: indexPath, withItem: item)
        }
        else{

            let item = medios.mediosBonificacion?[indexPath.section - 1].list?[indexPath.row]

            return configureCell(atIndexPath: indexPath, withItem: item)
            
        }
        
    }
    
    func configureCell(atIndexPath indexPath: IndexPath, withItem item: MediosBonificacion?) -> UITableViewCell{
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BancoCell", for: indexPath) as! BancoTableViewCell
            
            if let item = item{
                cell.lblAlias.text = item.aliasMedioBonificacion
                cell.lblCuenta.text = item.cuentaMedioBonificacion
                cell.lblTipo.text = item.banco ?? "Sin nombre"
            }
            
            return cell
        }
        else if( indexPath.section == 2 ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayPalCell", for: indexPath) as! PayPalTableViewCell
            
            cell.lblAlias.text = item?.aliasMedioBonificacion
            cell.lblID.text = item?.cuentaMedioBonificacion
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecargaCell", for: indexPath) as! RecargaTableViewCell
            cell.lblAlias.text = item?.aliasMedioBonificacion
            cell.lblNumero.text = item?.cuentaMedioBonificacion
            cell.lblCompania.text = item?.companiaMedioBonificacion
            
            return cell
        }
    }
    
    
}

extension MediosBonificacionTableViewController: MediosBonificacionControllerDelegate{
    
    func addItemViewController(_ controller: MediosBonificacionDetailViewController, didFinishAddind item: String) {
        lblMensaje.text = item
        
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
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
}

//MARK: - RESTActionDelegate
extension MediosBonificacionTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            let decoder = JSONDecoder()
            
            if identifier == ID_RQT_CATALOGO{
                medios = try decoder.decode(MediosBonificacionRSP.self, from: data)
                self.tableView.reloadData()
            }
            else{
                
            }
            
            
//            print(rsp)
//            tableView.reloadData()
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
