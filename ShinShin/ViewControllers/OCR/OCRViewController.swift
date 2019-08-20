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
//    @IBOutlet weak var txtResults: UITextView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnProcesar: UIButton!
    
    let ID_RQT_ANALIZAR = "ID_RQT_ANALIZAR"
    
    lazy var vision = Vision.vision()
    /// An overlay view that displays detection annotations.
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    var dic = [Int: [String]]()
//    var lines: [String] = [String]()
    var codigoBarras: String?
    var procesado = false
    var code = -1
    var datosTicket = OCRResponse()
    var photos: [UIImage]?
    var codeBar: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        imageView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            ])
        
        btnProcesar.layer.cornerRadius = 10.0
        btnProcesar.isEnabled = false
        btnProcesar.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        activity.isHidden = true
        
        configureBarButtons()
        
        if let photos = photos{
            clearResults()
            
            if let codeBar = codeBar{
                codigoBarras = codeBar
            }
            
            for (index, photo) in photos.enumerated() {
                updateImageView(with: photo, andIndex: index)
            }
        }
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
        //Consumir el servicio /tickets/analizar
        
//        performSegue(withIdentifier: "TicketDetailSegue", sender: self)
        analizarOCRRequest()
    }
    
    //MARK: - Helper methods
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
    
    private func clearResults() {
        removeDetectionAnnotations()
    }
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
    private func updateImageView(with image: UIImage, andIndex index: Int) {
        let orientation = UIApplication.shared.statusBarOrientation
        var scaledImageWidth: CGFloat = 0.0
        var scaledImageHeight: CGFloat = 0.0
        switch orientation {
        case .portrait, .portraitUpsideDown, .unknown:
            scaledImageWidth = imageView.bounds.size.width
            scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
        case .landscapeLeft, .landscapeRight:
            scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
            scaledImageHeight = imageView.bounds.size.height
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
            var scaledImage = image.scaledImage(
                with: CGSize(width: scaledImageWidth, height: scaledImageHeight)
            )
            scaledImage = scaledImage ?? image
            guard let finalImage = scaledImage else { return }
            DispatchQueue.main.async {
                self.imageView.image = finalImage
                self.detectTextFrom(finalImage, andIndex: index)
            }
        }
    }
    
    private func transformMatrix() -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale = (imageViewAspectRatio > imageAspectRatio) ?
            imageViewHeight / imageHeight :
            imageViewWidth / imageWidth
        
        // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
        // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
        
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    
    func analizarOCRRequest(){
        do{
            let encoder = JSONEncoder()
            let rqt = OCRRequest()
            var lineas = [String]()
            for index in 0..<dic.count {
                let l = dic[index]
                for s in l!{
                    lineas.append(s)
                }
            }
            
//            for( index, value ) in dic{
//                print("Index: \(index), lines: \(value)")
//            }
            
            rqt.lineas = lineas

            let json = try encoder.encode(rqt)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.analizarOCR, with: json, and: ID_RQT_ANALIZAR)
        }
        catch{
            
        }
    }
    
    @objc
    func showHome(){
        self.navigationController?.popViewController(animated: true)
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
    
    func clean(){
        removeDetectionAnnotations()
        imageView.image = nil
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CameraSegue"{
            let vc = segue.destination as! CustomCameraViewController
            vc.delegate = self
        }
        if segue.identifier == "TicketDetailSegue"{
            let vc = segue.destination as! DatosTicketViewController
            vc.datosTicket = datosTicket
            clean()
        }
        
        if segue.identifier == "ErrorTicketSegue"{
            let vc = segue.destination as! ErrorTicketViewController
            if code == 203{
                vc.mensaje = "No se detectaron productos válidos"
                clean()
            }
            vc.delegate = self
        }
    }
    
    //MARK: - MLVision
    func detectTextFrom(_ image: UIImage, andIndex index: Int){
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
            
            var lines = [String]()
            
            //Iterar sobre la respuesta
            for block in text.blocks{
                let transformedRect = block.frame.applying(self.transformMatrix())
                UIUtilities.addRectangle(
                    transformedRect,
                    to: self.annotationOverlayView,
                    color: UIColor.purple
                )
                
                for line in block.lines {
                    result.append(line.text + "\n")
                    let transformedRect = line.frame.applying(self.transformMatrix())
                    UIUtilities.addRectangle(
                        transformedRect,
                        to: self.annotationOverlayView,
                        color: UIColor.orange
                    )
                    
                    print("Line: \(line.text)")
                    lines.append(line.text)
//                    
//                    print("Elements")
//                    for element in line.elements{
//                        print(element.text)
//                    }
                }
            }
            
            self.dic[index] = lines
//            print("\(self.lines)")
            self.activity.stopAnimating()
            self.activity.isHidden = true
//            self.txtResults.text = result
            self.btnProcesar.isEnabled = true
            //255, 111, 0
            self.btnProcesar.backgroundColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1.0)
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

extension OCRViewController: CustomCameraControllerDelegate{
    func didCompletedTakePhoto(_ controller: CustomCameraViewController, withPhotos photos: [UIImage], and codeBar: String?) {
        clearResults()
        
        if let codeBar = codeBar{
            codigoBarras = codeBar
        }
        
        for (index, photo) in photos.enumerated() {
            updateImageView(with: photo, andIndex: index)
        }
        
        dismiss(animated: true)
    }
}

extension OCRViewController: ErrorTicketViewControllerDelegate{
    func didCompleted(_ controller: ErrorTicketViewController) {
        self.dismiss(animated: true, completion: nil)
        
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is CustomCameraViewController {
                _ = self.navigationController?.popToViewController(vc as! CustomCameraViewController, animated: true)
            }
        }
    }
}

extension OCRViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        clearResults()
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            updateImageView(with: pickedImage, andIndex: 0)
            //Verificar si se requiere ajustar la imagen
//            imageView.image = pickedImage
            
            
        }
        dismiss(animated: true)
    }
}

//MARK: - RESTActionDelegate
extension OCRViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        if identifier == ID_RQT_ANALIZAR{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(OCRResponse.self, from: data)
                if rsp.code == 200{
                    datosTicket = rsp
                    performSegue(withIdentifier: "TicketDetailSegue", sender: self)
                }
                else if rsp.code == 203{
                    print("No existen productos")
                    code = 203
                    performSegue(withIdentifier: "ErrorTicketSegue", sender: self)
                }
                else{
                    //Dirigir a pantalla de error
                    performSegue(withIdentifier: "ErrorTicketSegue", sender: self)
//                    self.showOCRError()
                }
            }
            catch{
                print("JSON Error: \(error)")
            }
        }
    }
    
    func restActionDidError() {
        self.showNetworkError()
    }
    
    func showNetworkError(){
        let alert = UIAlertController(
            title: "Whoops...",
            message: "Ocurrió un problema." +
            " Favor de interntar nuevamente",
            preferredStyle: .alert)
        
        let action =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showOCRError(){
        let alert = UIAlertController(
            title: "Whoops...",
            message: "No se detectaron productos válidos",
            preferredStyle: .alert)
        
        let action =
            UIAlertAction(title: "OK",
                          style: .default,
                          handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
