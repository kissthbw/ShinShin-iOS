//
//  ActivacionTableViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/28/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ActivacionTableViewController: UITableViewController {

    @IBOutlet weak var txtField1: UITextField!
    @IBOutlet weak var txtField2: UITextField!
    @IBOutlet weak var txtField3: UITextField!
    @IBOutlet weak var txtField4: UITextField!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var v4: UIView!
    @IBOutlet weak var btnValidar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtField1.delegate = self
        txtField2.delegate = self
        txtField3.delegate = self
        txtField4.delegate = self
        
        v1.layer.cornerRadius = 10.0
        v2.layer.cornerRadius = 10.0
        v3.layer.cornerRadius = 10.0
        v4.layer.cornerRadius = 10.0
        btnValidar.layer.cornerRadius = 10.0
        
        txtField1.tag = 1
        txtField2.tag = 2
        txtField3.tag = 3
        txtField4.tag = 4
        
        txtField1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txtField2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txtField3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        txtField4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //MARK: - Actions
    @IBAction func activateAction(_ sender: Any){
        print("Activando usuario")
        activateRequest()
    }
    
    //Helper methods
    func activateRequest(){
        let user = Usuario()
        user.idUsuario = Model.user?.idUsuario
        let c1 = txtField1.text!
        let c2 = txtField2.text!
        let c3 = txtField3.text!
        let c4 = txtField4.text!
        
        user.codigoVerificacion = c1 + c2 + c3 + c4
        
        do{
            let encoder = JSONEncoder()
            let json = try  encoder.encode(user)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.activarUsuario, with: json, and: "ACTIVATE")
        }
        catch{
            
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if text?.utf16.count==1{
            switch textField{
            case txtField1:
                txtField2.becomeFirstResponder()
            case txtField2:
                txtField3.becomeFirstResponder()
            case txtField3:
                txtField4.becomeFirstResponder()
            case txtField4:
                txtField4.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Extensions
extension ActivacionTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if( textField.text?.count == 1 ){
//            txtField1.resignFirstResponder()
//            txtField2.becomeFirstResponder()
//            return true
//        }
        
        return true
//        return textField.shouldChangeCustomOtp(textField: textField, string: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("End")
    }
}

extension UITextField {
    func shouldChangeCustomOtp(textField:UITextField, string: String) ->Bool {
        
        //Check if textField has two chacraters
        if ((textField.text?.count)! == 0  && string.count > 0) {
            let nextTag = textField.tag + 1;
            
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag);
            if (nextResponder == nil) {
                nextResponder = textField.superview?.viewWithTag(1);
            }
            
            textField.text = textField.text! + string;
            //write here your last textfield tag
            if textField.tag == 2 {
                //Dissmiss keyboard on last entry
                textField.resignFirstResponder()
            }
            else {
                ///Appear keyboard
                nextResponder?.becomeFirstResponder();
            }
            return false;
        } else if ((textField.text?.count)! == 0  && string.count == 0) {// on deleteing value from Textfield
            
            let previousTag = textField.tag - 1;
            // get prev responder
            var previousResponder = textField.superview?.viewWithTag(previousTag);
            if (previousResponder == nil) {
                previousResponder = textField.superview?.viewWithTag(1);
            }
            textField.text = "";
            previousResponder?.becomeFirstResponder();
            return false
        }
        return true
        
    }
    
}

//MARK: - RESTActionDelegate
extension ActivacionTableViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        print( "restActionDidSuccessful: \(data)" )
        
        do{
            let decoder = JSONDecoder()
            
            let rsp = try decoder.decode(SimpleResponse.self, from: data)
            if rsp.code == 200{
                let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "PrincipalNavigationController")
                //        self.navigationController!.pushViewController(destViewController, animated: true)
                self.present(destViewController, animated: true, completion: nil)
            }
            else if rsp.code == 500{
                showMessage(message: "El usuario ya existe")
            }
        }
        catch{
            print("JSON Error: \(error)")
        }
    }
    
    func restActionDidError() {
        
    }
    
    func showMessage(message: String){
        let alert = UIAlertController(
            title: "Whoops...",
            message: message,
            preferredStyle: .alert)
        
        let action =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
