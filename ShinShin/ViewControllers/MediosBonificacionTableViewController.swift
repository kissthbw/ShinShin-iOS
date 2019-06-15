//
//  MediosBonificacionTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class MediosBonificacionTableViewController: UIViewController {
    
    var sectionSelected = -1
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Helper methods
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
        let imageView = UIImageView(frame: CGRect(x: 5, y: 6, width: 35, height: 35))
        imageView.image = UIImage(named: "producto_detail_placeholder")
        header.addSubview(imageView)
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "       Bancarias"
        }
        else if section == 1{
            return "       PayPal"
        }
        else{
            return "       Recargas telefónicas"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BancoCell", for: indexPath) as! BancoTableViewCell
            cell.lblCuenta.text = "2159****"
            cell.lblVigencia.text = "02/24"
            cell.lblTipo.text = "Visa"
            
            
            return cell
        }
        else if indexPath.section == 1{
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
