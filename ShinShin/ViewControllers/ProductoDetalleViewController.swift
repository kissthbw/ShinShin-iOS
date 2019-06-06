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

class ProductoDetalleViewController: UIViewController {

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
    
    //MARK: - UIActions
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
