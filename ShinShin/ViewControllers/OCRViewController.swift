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

class OCRViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var vision = Vision.vision()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - Actions
    @IBAction func takePhoto(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        present(vc, animated: true)
    }
    
    //MARK: - Helper methods
    //MARK: - MLVision
    func detectTextFrom(_ image: UIImage){
        
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
                
                for line in block.lines {
                    print("\(line.text)")
//                    for element in line.elements{
//                        print(element.text)
//                    }
                }
            }
        }
        
        performSegue(withIdentifier: "TicketDetailSegue", sender: self)
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
