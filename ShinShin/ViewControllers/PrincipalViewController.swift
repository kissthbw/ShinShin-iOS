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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notif = UIBarButtonItem(
            image: UIImage(named: "notif_placeholder"),
            style: .plain,
            target: self,
            action: #selector(notifications))
        notif.tintColor = .black
        
        let user = UIBarButtonItem(
            image: UIImage(named: "user_placeholder"),
            style: .plain,
            target: self,
            action: #selector(notifications))
        user.tintColor = .black
        navigationItem.rightBarButtonItems = [user, notif]
    }
    
    @objc
    func notifications(){
    }

    //MARK: - UIActios
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        let button  = sender as! UIButton
//        print("Tag del boton: \(button.tag)")
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
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularesCell", for: indexPath) as! PopularTableViewCell
            
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepartamentosCell", for: indexPath) as! DeptoTableViewCell
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TiendasCell", for: indexPath) as! TiendaTableViewCell
            
            return cell
        }
        
    }
    
    
}
