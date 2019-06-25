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
    var item: Producto? = nil
    
    @IBOutlet weak var topFrame: UIView!
    @IBOutlet weak var bottomframe: UIView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPresentacion: UILabel!
    @IBOutlet weak var lblBonificacion: UILabel!
    @IBOutlet weak var txtDescripcion: UITextView!
    @IBOutlet weak var imgProducto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationBar.tintColor = UIColor.orange
//        navigationBar.barTintColor = UIColor.lightGray
        
        configureBarButtons()
        
        // Do any additional setup after loading the view.
        if let edititem = item{
            self.navigationController?.navigationBar.barTintColor = UIColor.orange
            topFrame.layer.borderWidth = 0.0
            topFrame.backgroundColor = UIColor.orange
            bottomframe.layer.borderWidth = 0.0
            bottomframe.layer.cornerRadius = 20.0
            bottomframe.backgroundColor = UIColor.orange
            lblNombre.text = edititem.nombreProducto
            lblPresentacion.text = edititem.contenido
            txtDescripcion.textAlignment = .left
            txtDescripcion.text = edititem.descripcion
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            let tmp = NSNumber(value: edititem.cantidadBonificacion!)
            if let bon = formatter.string(from: tmp){
                lblBonificacion.text = bon
            }

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    //MARK: - Actions
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    @objc
    func showHome(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func showNotif(){
        let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "NotificacionesTableViewController")
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @objc
    func showMenu(){
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
}
