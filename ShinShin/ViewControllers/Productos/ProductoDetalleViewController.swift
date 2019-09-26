//
//  ProductoDetalleViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 3/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

/*
 La funcionalidad general de este clase es:
 Poder ver el detalle del producto participante
 Calificar el producto (Se permisiste esta calificacion en local y en back)
 Agregar el producto a favoritos (Se permisiste esta calificacion en local y en back)
 */

import UIKit
import SideMenu

class ProductoDetalleViewController: UIViewController {

    //MARK: - Propiedades
    @IBOutlet weak var topFrame: UIView!
    @IBOutlet weak var bottomframe: UIView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPresentacion: UILabel!
    @IBOutlet weak var lblBonificacion2: UILabel!
    @IBOutlet weak var txtDescripcion: UITextView!
    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var fakeView: UIView!
    
    //MARK: - Revisar
    //Esto debe ser dinamico
    @IBOutlet weak var icon1: UIView!
    @IBOutlet weak var icon2: UIView!
    @IBOutlet weak var icon3: UIView!
    @IBOutlet weak var icon4: UIView!
    @IBOutlet weak var icon5: UIView!
    @IBOutlet weak var icon6: UIView!
    @IBOutlet weak var icon7: UIView!
    @IBOutlet weak var icon8: UIView!
    @IBOutlet weak var icon9: UIView!
    @IBOutlet weak var icon10: UIView!
    
    var item: Producto? = nil
    var color: UIColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
//        navigationBar.tintColor = UIColor.orange
//        navigationBar.barTintColor = UIColor.lightGray
        configureBarButtons()
        
        // Do any additional setup after loading the view.
        if let edititem = item{
            
            if let colorBanner = edititem.colorBanner{
                let components = colorBanner.components(separatedBy: ",")
                
                let r = CGFloat(Float(components[0]) ?? 0.0)
                let g = CGFloat(Float(components[1]) ?? 0.0)
                let b = CGFloat(Float(components[2]) ?? 0.0)
                
                //Enviar a Robert
                color = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
                self.navigationController?.navigationBar.barTintColor = color
                bottomframe.backgroundColor = color
                fakeView.backgroundColor = color
                topFrame.backgroundColor = color
            }
            
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = color
            fakeView.backgroundColor = color
            topFrame.layer.borderWidth = 0.0
            topFrame.backgroundColor = color
            bottomframe.layer.borderWidth = 0.0
            bottomframe.layer.cornerRadius = 20.0
            bottomframe.backgroundColor = color
            lblNombre.text = edititem.nombreProducto
            lblPresentacion.text = edititem.contenido
            txtDescripcion.textAlignment = .left
            txtDescripcion.text = edititem.descripcion
            lblBonificacion2.text = Validations.formatWith(edititem.cantidadBonificacion)
            

        }
        
        lblBonificacion2.layer.cornerRadius = 10.0
        lblBonificacion2.layer.masksToBounds = true
        
        icon1.layer.cornerRadius = 10.0
        icon2.layer.cornerRadius = 10.0
        icon3.layer.cornerRadius = 10.0
        icon4.layer.cornerRadius = 10.0
        icon5.layer.cornerRadius = 10.0
        icon6.layer.cornerRadius = 10.0
        icon7.layer.cornerRadius = 10.0
        icon8.layer.cornerRadius = 10.0
        icon9.layer.cornerRadius = 10.0
        icon10.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for:.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    //MARK: - Actions
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
}
