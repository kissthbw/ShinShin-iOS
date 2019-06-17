//
//  SideMenuViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/12/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol SideMenuDelegate {
    func sideMenuItemSelectedAtIndex(_ index : Int)
}

class SideMenuViewController: UITableViewController {

    var delegate: SideMenuDelegate?
    @IBOutlet weak var btnRetirar: UIButton!
    @IBOutlet weak var btnHistorial: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIElements()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - UIActions
    @IBAction func selectOptionAction(_ sender: Any) {
        selectedOption(5)
    }
    
    
    //MARK: - Helper methods
    func initUIElements(){
        btnRetirar.layer.cornerRadius = 10.0
        btnHistorial.layer.cornerRadius = 10.0
    }
    func selectedOption( _ option: Int ){
        if (self.delegate != nil) {
//            performSegue(withIdentifier: "PrincipalSegue", sender: self)
            delegate?.sideMenuItemSelectedAtIndex(option)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if indexPath.row == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
//            
//            
//            return cell
//        }
//        if indexPath.row == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PerfilCell", for: indexPath)
//            
//            
//            return cell
//        }
//        if indexPath.row == 2{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CuentasCell", for: indexPath)
//            
//            
//            return cell
//        }
//        if indexPath.row == 3{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AyudaCell", for: indexPath)
//            
//            
//            return cell
//        }
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell", for: indexPath)
//            
//            return cell
//        }
//        
//        
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption( indexPath.row )
    }
}
