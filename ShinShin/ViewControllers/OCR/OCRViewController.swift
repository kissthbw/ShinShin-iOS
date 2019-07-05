//
//  OCRViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 3/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

/*
 La funcionalidad general de este clase es:
 Poder escaner y reconocer tickets de ventas, de los cuales se extraeran la lista de
 productos participantes
 
 */

import UIKit
import FirebaseMLVision
import SideMenu

class OCRViewController: UIViewController {
    
    //MARK: - Propiedades
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtResults: UITextView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnProcesar: UIButton!
    
    lazy var vision = Vision.vision()
    var lines: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnProcesar.layer.cornerRadius = 10.0
        btnProcesar.isEnabled = false
        activity.isHidden = true
        
        configureBarButtons()
    }
    

    //MARK: - Actions
    @IBAction func takePhoto(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func procesarAction(_ sender: Any) {
        performSegue(withIdentifier: "TicketDetailSegue", sender: self)
    }
    
    //MARK: - Helper methods
    func configureBarButtons(){
        let img = UIImage(named: "money-grey")
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 4, y: 6, width: 22, height: 22)
        
        let lblBonificacion = UILabel()
        lblBonificacion.font = UIFont(name: "Nunito SemiBold", size: 17)
        lblBonificacion.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        lblBonificacion.text = Validations.formatWith(Model.totalBonificacion)
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
    
    //MARK: - MLVision
    func detectTextFrom(_ image: UIImage){
        activity.isHidden = false
        activity.startAnimating()
        var result = ""
        print("Procesando imagen")
        //1
        let textRecognizer = vision.onDeviceTextRecognizer()
        
        //2
        let metadata = VisionImageMetadata()
        metadata.orientation = visionImageOrientation(from: image.imageOrientation)
        
        //3
        let visionImage = VisionImage(image: image)
        visionImage.metadata = metadata
        
        
        textRecognizer.process(visionImage){text, error in
            guard error == nil, let text = text else {
                let errorString = error?.localizedDescription ?? "Error"
                print("\(errorString)")
                return
            }
            
            //Iterar sobre la respuesta
            for block in text.blocks{
                print("Block: \(block.text)" )
                
                for line in block.lines {
                    result.append(line.text + "\n")
                    self.lines.append(line.text)
//                    
//                    print("Elements")
//                    for element in line.elements{
//                        print(element.text)
//                    }
                }
            }
            
//            print("\(self.lines)")
            
            TicketOCRAnalyzer.analize(self.lines)
            
            self.activity.stopAnimating()
            self.activity.isHidden = true
            self.txtResults.text = result
            self.btnProcesar.isEnabled = true
        }
    }
    
    func visionImageOrientation(
        from imageOrientation: UIImage.Orientation
        ) -> VisionDetectorImageOrientation {
        switch imageOrientation {
        case .up:
            return .topLeft
        case .down:
            return .bottomRight
        case .left:
            return .leftBottom
        case .right:
            return .rightTop
        case .upMirrored:
            return .topRight
        case .downMirrored:
            return .bottomLeft
        case .leftMirrored:
            return .leftTop
        case .rightMirrored:
            return .rightBottom
        @unknown default:
            return .topLeft
        }
    }
}

extension OCRViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        print( "Size: \(image.size)" )
        print( "Description: \(image.description)" )
        
        
        //Verificar si se requiere ajustar la imagen
        imageView.image = image
        
        detectTextFrom(image)
    }
}
