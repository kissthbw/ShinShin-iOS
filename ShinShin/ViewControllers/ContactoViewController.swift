//
//  ContactoViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/6/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ContactoViewController: UIViewController {
    @IBOutlet weak var txt1: UITextView!
    @IBOutlet weak var txt2: UITextView!
    @IBOutlet weak var btnEnviar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txt1.backgroundColor = UIColor.gray
        txt2.backgroundColor = UIColor.gray
        btnEnviar.layer.cornerRadius = 5.0
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
