//
//  AyudaViewControlller.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/2/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import SideMenu

class AyudaViewControlller: UITableViewController {

    //MARK: - Propiedades
    var toggle = false
    var previusSelectedRow = -1
    var selectedRow = -1
    var primeraVez = true
    
    var item1 = FAQ()
    let item2 = FAQ()
    let item3 = FAQ()
    let item4 = FAQ()
    let item5 = FAQ()
    let item6 = FAQ()
    
    
    var preguntas: [FAQ] = [FAQ]()
    let sections = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isTranslucent = false
        
            item1.pregunta = "¿Qué es Shing Shing?"
            item1.respuesta = "Es la app que te da $ por tus compras que realizas en las principales tiendas de autoservicios en México, como lo son Aurera, Chedraui, Costco, Comercial, Extra, Neto, Oxxo, Soriana, Superama y Waltmart Así que, no lo olvides, guarda tus Tickets y tómale una foto desde la app para comenzar a ganar $ por tus compras. ¡Haz Shing Shing!"
        
            item2.pregunta = "¿Qué Productos participan?"
            item2.respuesta = "Algunos de los productos que te dan $ por comprarlos y escanear el ticket de su compra son: Cuéntanos, ¿Qué producto te gustaría que te diera $ por comprarlo? (Input)"
        
            item3.pregunta = "¿Qué Tickets puedo subir?"
            item3.respuesta = "Todos los Tickets de las principales tiendas de auto servicio como, Aurera, Chedraui, Costco, Comercial, Extra, Neto, Oxxo, Soriana, Superama y Waltmart."
        
            item4.pregunta = "¿Tengo límite de tickets para subir?"
            item4.respuesta = "No! Sube cuantos tickets tengamos ;-)"
        
            item5.pregunta = "¿Cuánto tiempo tarda en verse reflejado el dinero en mi cuenta Bacaria/Paypal?"
            item5.respuesta = "Es muy rapido, no más de 24 horas despues de haber solicitado el retiro.En caso de haberlo solicitado en fín de semana, en el transcurso del siguiente día hábil, verás el deposito reflejado en tu cuenta.En el caso de las recargas teléfonicas, pasan inmediatamente."
        
            item6.pregunta = "¿Cuánto es lo mínimo que puedo retirar de mi cuenta?"
            item6.respuesta = "Desde $10 y hasta $500 por día"

        preguntas.append(item1)
        preguntas.append(item2)
        preguntas.append(item3)
        preguntas.append(item4)
        preguntas.append(item5)
        preguntas.append(item6)
        configureBarButtons()
        initUIElements()
    }

    //MARK: - Actions
    
    //MARK: - Helper methods
    func initUIElements(){
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
            action: #selector(showHome))
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

//MARK: - Extensions
extension AyudaViewControlller{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return preguntas.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 280
        }else{
            if toggle && selectedRow == indexPath.row{
//                if previewSelectedRow > -1{
//                    return 48
//                }
//                else{
//                    return 300
//                }
                return 300
            }
            else{
                return 48
            }
//            return 300
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        else{
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            let header = Bundle.main.loadNibNamed("PreguntasHeader", owner: nil, options: nil)!.first as! UIView
            
            return header
        }
        else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AyudaCell", for: indexPath) as! AyudaTableViewCell
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreguntaCell", for: indexPath) as! PreguntaTableViewCell
            cell.lblPregunta.text = preguntas[indexPath.row].pregunta
            cell.txtRespuesta.text = preguntas[indexPath.row].respuesta
            cell.tag = indexPath.row
            cell.btnShow.tag = indexPath.row
//            cell.btnShow.addTarget(self, action: #selector(mostrarRespuesta), for: .touchUpInside)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
        toggle = !toggle
        
        selectedRow = indexPath.row
        if primeraVez{
            primeraVez = false
            previusSelectedRow = selectedRow
        }
        
        if indexPath.row == previusSelectedRow{
            previusSelectedRow = selectedRow
            print("Misma row")
        }
        else{
            previusSelectedRow = indexPath.row
            print("Seleciona otra row")
        }
    
        
//        previewSelectedRow = indexPath.row
        
        tableView.beginUpdates()
        tableView.endUpdates()
        }
    
//    @objc func mostrarRespuesta(_ sender: Any?){
//        let cell = sender as? UIButton
//        print( "Row selected: \(cell?.tag)" )
//    }
}
