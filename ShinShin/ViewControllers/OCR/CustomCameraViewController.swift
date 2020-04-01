//
//  CustomCameraViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/15/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseMLVision
import ZXingObjC

protocol CustomCameraControllerDelegate: class{

    func didCompletedTakePhoto(_ controller: CustomCameraViewController, withPhotos photos: [UIImage], and codeBar: String?)
}

class CustomCameraViewController: UIViewController {

    //MARK: - Propiedades Oulets
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
//    @IBOutlet weak var switchFase: UISwitch!
    @IBOutlet weak var previewView: UIView!
    
    //Sirve como holder, una vez tomada la foto, se pone de forms temporal
    //para su posterior analisis
    @IBOutlet weak var imageView: UIImageView!
    
    //Sirve como salida de la camara (se muestra lo que la camara visualice)
    @IBOutlet weak var previewPhoto: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var lblCodigoBarras: UILabel!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnBorrar: UIButton!
//    @IBOutlet weak var btnOmitir: UIButton!
//    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var outterGuideView: UIView!
    @IBOutlet weak var innerGuideView: UIView!
    @IBOutlet weak var controlesCamaraView: UIView!
    
    //MARK: - Propiedades uso de MLVision
    lazy var vision = Vision.vision()
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    //MARK: - Propiedades
    var codigoBarras: String?
    var photos: [UIImage] = [UIImage]()
    var dic = [Int: [String]]()
    var code = -1
    var datosTicket = OCRResponse()
    var visiblePreview = false
    var toogleFlash = false
    
    let ID_RQT_ANALIZAR = "ID_RQT_ANALIZAR"
    
    enum Fase {
        case inicial
        case escaner
        case camara
    }
    
    enum From {
        case normal
        case detail
    }
    
    var fase: Fase = .camara
    var from: From = .normal
    
    //MARK: - Propiedades para ZXCapture
    @IBOutlet weak var scanView: UIView?
    fileprivate var capture: ZXCapture?
    fileprivate var isScanning: Bool?
    fileprivate var isFirstApplyOrientation: Bool?
    fileprivate var captureSizeTransform: CGAffineTransform?
    
    private let sessionQueue = DispatchQueue(label: "Capture Session Queue")
    private let sessionZXQueue = DispatchQueue(label: "ZXCapture")
    weak var delegate: CustomCameraControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        btnOk.alpha = 0.0
        Model.primeraVezCamara = true
        
        //Si es primera vez, mostrar intro
        if Model.isCameraFirtsTime(){
            let destViewController = self.storyboard!.instantiateViewController(withIdentifier: "CameraTutorialViewController")
            destViewController.modalPresentationStyle = .fullScreen
            destViewController.modalTransitionStyle = .coverVertical
            
            Model.handleCameraFirstTime()
            
            self.present(destViewController, animated: true, completion: nil)
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Este metodo es llamada cada vez que los limites del view del
    //ViewController cambia, es responsabilidad del programador hacer los
    //ajustes necesarios en cada elemento
    override func viewDidLayoutSubviews(){
        //El cambio sólo debe aplicar cuando esta habilitado el modo
        //de escaneo
        if fase == .escaner{
            if isFirstApplyOrientation == true { return }
            isFirstApplyOrientation = true
            applyOrientation()
        }
    }
    
    //Notifica al contenedor que el tamaño de su view va a cambiar
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if fase == .escaner{
            super.viewWillTransition(to: size, with: coordinator)
            
            coordinator.animate(alongsideTransition: { (context) in
                // do nothing
            }) { [weak self] (context) in
                guard let weakSelf = self else { return }
                weakSelf.applyOrientation()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fase = .camara
        print( "ViewWillAppear: \(self.outterGuideView.frame)" )
        
        if fase == .camara{
            setupCaptureSession()
        }
        else if( fase == .escaner ){
            ZXSetup()
        }
        
        if !Model.mantenerCamara{
            photos = [UIImage]()
           initUIElements()
        }
        
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print( "ViewDidAppear: \(self.outterGuideView.frame)" )
        
        if( Model.primeraVezCamara ){
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.outterGuideView.bounds.size.width, height: self.outterGuideView.bounds.size.height), cornerRadius: 0)
            
            let circlePath = UIBezierPath(roundedRect: innerGuideView.frame, cornerRadius: 10)
            path.append(circlePath)
            path.usesEvenOddFillRule = true

            let fillLayer = CAShapeLayer()
            fillLayer.path = path.cgPath
            fillLayer.fillRule = .evenOdd
            fillLayer.fillColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
            fillLayer.opacity = 1.0
            outterGuideView.layer.addSublayer(fillLayer)
            
            Model.primeraVezCamara = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
//        Model.mantenerCamara = false
        
        if fase == .camara{
            if self.captureSession != nil{
                self.captureSession.stopRunning()
            }
        }
        else if fase == .escaner{
            capture?.stop()
            isScanning = false
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        delegate?.didCompletedTakePhoto(self, withPhotos: photos, and: codigoBarras)
        if segue.identifier == "DetalleFotosSegue"{
            Model.mantenerCamara = true
            let vc = segue.destination as! DetalleFotosViewController
            vc.photos = self.photos
            vc.delegate = self
        }
        if segue.identifier == "DetalleFotoSegue"{
            Model.mantenerCamara = false
            let vc = segue.destination as! OCRViewController
            vc.photos = photos
            vc.codeBar = codigoBarras
        }
        if segue.identifier == "TicketDetailSegue"{
            Model.mantenerCamara = false
            let vc = segue.destination as! DatosTicketViewController
            vc.datosTicket = datosTicket
            vc.photos = self.photos
            clean()
        }
        
        if segue.identifier == "ErrorTicketSegue"{
            Model.mantenerCamara = false
            let vc = segue.destination as! ErrorTicketViewController
            if code == 203{
                vc.mensaje = "No se detectaron productos válidos"
                clean()
            }
            vc.delegate = self
        }
    }
    
    //MARK: - Actions
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func cerrar(_ sender: Any) {
        Model.mantenerCamara = false
        
        if fase == .camara{
            if self.captureSession != nil{
                self.captureSession.stopRunning()
            }
            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
        }
        else if fase == .escaner{
            //[self.capture.layer removeFromSuperlayer];
            self.capture?.layer.removeFromSuperlayer()
            capture?.stop()
            isScanning = false
            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func toggleFlashAction(_ sender: Any) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        
        guard device.hasTorch else {
            return
        }
        
        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
//    @IBAction func changeFase(_ sender: Any) {
//
//        if switchFase.isOn{
//            fase = .escaner
//        }
//        else{
//            fase = .camara
//        }
//
//        DispatchQueue.main.async {
//            self.indicator.isHidden = false
//            self.indicator.startAnimating()
//            self.manejaFases()
//        }
//    }
    
    @IBAction func OKAction(_ sender: Any) {
        analizarOCRRequest()
    }
    
    @IBAction func DELETEAction(_ sender: Any) {
        resetUICamara()
    }
    
    @IBAction func OMITIRAction(_ sender: Any) {
        performSegue(withIdentifier: "TicketDetailSegue", sender: self)
    }
    
    //MARK: - Animation methods
    func resetUICamara(){
        photos = [UIImage]()
        dic = [Int: [String]]()
        visiblePreview = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.previewPhoto.alpha = 0.0
            self.checkImage.alpha = 0.0
            self.previewButton.alpha = 0.0
            self.previewButton.isEnabled = false
//            self.btnOk.alpha = 0.0
//            self.btnOk.isEnabled = false
            self.btnBorrar.alpha = 0.0
            self.btnBorrar.isEnabled = false
        }) { (Bool) in
            self.previewPhoto.image = nil
        }
    }
    
    func manejaFases(){
        var alpha: CGFloat  = 1.0
        var alphaGuideView: CGFloat  = 1.0
        var bottomConstant: CGFloat = 0.0
        self.previewView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        if fase == .escaner{
            alpha = 1.0
            alphaGuideView = 0.0
            bottomConstant = 150.0
            captureSession.stopRunning()
            ZXSetup()
        }
        else{
            alpha = 0.0
            alphaGuideView = 1.0
            bottomConstant = 0.0
            //[self.capture.layer removeFromSuperlayer];
            self.capture?.layer.removeFromSuperlayer()
            capture?.stop()
            isScanning = false
            setupCaptureSession()
        }
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.scanView?.alpha = alpha
//                        self.btnOmitir.alpha = alpha
//                        self.btnOmitir.isEnabled = true
        },
                       completion: nil)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.bottomConstraint.constant = bottomConstant
                        self.outterGuideView.alpha = alphaGuideView
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    //MARK: - Helper methods
    func clean(){
        imageView.image = nil
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
            
//
//            lineas = [String]()
//            lineas.append("BodegaAurera")
//            lineas.append("NEVA WAL MART DE MEXICO S DE RL DE Cy")
//            lineas.append("NEXTENGO 78 STA. CRUZ ACAYUCAN 0270")
//            lineas.append("AZCAPOTZALCO MEX COMX RFC NeM9709244M4")
//            lineas.append("UNTDAD AV. GUADALUPE")
//            lineas.append("AV. GUADALUPE # 41 COL PATITLAN")
//            lineas.append("CP. 08100 DEL 1ZTACALCO COMX")
//            lineas.append("OUE JAS Y SUGERENCIAS 01 800 71052")
//            lineas.append("REGIMEN GENERAL OE LEY PERSONAS MORALES")
//            lineas.append("TDAN2229 0PHOO0O0027 TEN 002 TRH 07528")
//            lineas.append("AGUA NATURAL EPURA 5 LT")
//            lineas.append("21.80C")
//            lineas.append("21.80")
//            lineas.append("2 X $10.90 $")
//            lineas.append("TOTAL")
//            lineas.append("5280")
//            lineas.append("500.00")
//            lineas.append("500.00")
//            lineas.append("BANDOMER")
//            lineas.append("COMPRA")
//            lineas.append("RETIRO")
//            lineas.append("CAMBIO")
//            lineas.append("VEINTTUN PESOS 80/100 M.N")
//            lineas.append("vISA ELEC1RON")
//            lineas.append("7809")
//            lineas.append("521 80")
//            lineas.append("201121")
//            lineas.append("6533533")
//            lineas.append("A0OO0000032010")
//            lineas.append("C864BF 2198F5")
//            lineas.append("TARJETA")
//            lineas.append("CUENTA")
//            lineas.append("TMPORIatON")
//            lineas.append("AUTORI 2ACTON")
//            lineas.append("AROC")
//            lineas.append("B,0X $")
//            lineas.append("20 18$")
//            lineas.append("1.62")
//            lineas.append("1 62")
//            lineas.append("LEPS")
//            lineas.append("TEPS")
            
 
            rqt.lineas = lineas
            
            let json = try encoder.encode(rqt)
            RESTHandler.delegate = self
            RESTHandler.postOperationTo(RESTHandler.analizarOCR, with: json, and: ID_RQT_ANALIZAR)
        }
        catch{
            
        }
    }

    func initUIElements(){
        //De acuerdo al flujo deben esar deshabilitados los componentes
        //referentes a la captura de codigo de barras o la camara
        //
        indicator.isHidden = true
        lblCodigoBarras.text = ""
        lblCodigoBarras.text = ""
//        switchFase.isHidden = true
        visiblePreview = false
        previewPhoto.image = nil
        
        codigoBarras = ""
        
        previewButton.layer.cornerRadius = 10.0
        previewPhoto.layer.cornerRadius = 10.0
        
        if fase == .camara{
//            btnOk.alpha = 0.0
//            btnOk.isEnabled = false
//            btnOmitir.alpha = 0.0
//            btnOmitir.isEnabled = false
            btnBorrar.alpha = 0.0
            btnBorrar.isEnabled = false
            previewButton.alpha = 0.0
            previewButton.isEnabled = false
            checkImage.alpha = 0.0
            scanView?.isHidden = false
            scanView?.alpha = 0.0
            bottomConstraint.constant = 0.0
        }
        else if fase == .escaner{
            scanView?.isHidden = false
            scanView?.alpha = 1.0
            bottomConstraint.constant = 150.0
        }
    }
    
    //MARK: - Camera Session
    func setupCaptureSession(){
        sessionQueue.sync {
            captureSession = AVCaptureSession()
            
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = .high

            
            guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
                else {
                    print("Unable to access back camera!")
                    captureSession = nil
                    return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                
                if(backCamera.isFocusModeSupported(.continuousAutoFocus)) {
                    try! backCamera.lockForConfiguration()
                    backCamera.focusMode = .continuousAutoFocus
//                    backCamera.exposureMode = .autoExpose
                    backCamera.unlockForConfiguration()
                }
                
                //Step 9
                self.stillImageOutput = AVCapturePhotoOutput()
                
                if self.captureSession.canAddInput(input) && self.captureSession.canAddOutput(self.stillImageOutput) {
                    self.captureSession.addInput(input)
                    self.captureSession.addOutput(stillImageOutput)
//                    setupLivePreview()
                }
            }
            catch let error  {
                print("Error Unable to initialize back camera:  \(error.localizedDescription)")
            }
            
            self.captureSession.commitConfiguration()
            
            DispatchQueue.main.async {
                self.setupLivePreview()
                self.indicator.stopAnimating()
                self.indicator.isHidden = true

                //                self.setupPreviewLayer(session: self.captureSession)
                //                self.setupBoundingBox()
            }
            
            self.captureSession.startRunning()
        }
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        self.videoPreviewLayer.frame = self.previewView.bounds
        
//        //Step12
//        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
//            self.captureSession.startRunning()
//            //Step 13
//            DispatchQueue.main.async {
//                self.videoPreviewLayer.frame = self.previewView.bounds
//            }
//        }
    }
}

extension CustomCameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        
        if let image = image{
            
            //Si los lblCountPhotos y previewPhoto estan ocultos se deben mostrar
            if !visiblePreview{
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.previewPhoto.alpha = 1.0
                    self.checkImage.alpha = 1.0
                    self.previewButton.alpha = 1.0
                    self.previewButton.isEnabled = true
//                    self.previewButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: {_ in
//                    self.previewButton.transform = CGAffineTransform.identity
                })
                
                
                visiblePreview = !visiblePreview
            }
            else{
                self.previewButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

                UIView.animate(withDuration: 2.0,
                                           delay: 0,
                                           usingSpringWithDamping: CGFloat(0.20),
                                           initialSpringVelocity: CGFloat(6.0),
                                           options: UIView.AnimationOptions.allowUserInteraction,
                                           animations: {
                                            self.previewButton.transform = CGAffineTransform.identity
                    },
                                           completion: { Void in()  }
                )
            }

            //Cortar imagen en proporcion innerGuideView
            var tmpImage = UIImage()
            if let cropImage = cropImage(originalImage: image){
                tmpImage = cropImage
            }else{
                tmpImage = image
            }
            
            photos.append(tmpImage)
            
            //El preview solo se realiza para la primer foto
//            if photos.count == 1{
            updateImageView(with: tmpImage, isPreview: true, andIndex: 0)
//            }
            
            updateImageView(with: tmpImage, isPreview: false, andIndex: 0)
        }

    }
    
    private func cropImage(originalImage: UIImage) -> UIImage?{
        let originalSize: CGSize
        let visibleLayerFrame = self.innerGuideView.frame
        
        let metaRect = (videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: visibleLayerFrame )) ?? CGRect.zero
        
        if (originalImage.imageOrientation == UIImage.Orientation.left || originalImage.imageOrientation == UIImage.Orientation.right) {
            originalSize = CGSize(width: originalImage.size.height, height: originalImage.size.width)
        } else {
            originalSize = originalImage.size
        }
        
        let cropRect: CGRect = CGRect(x: metaRect.origin.x * originalSize.width, y: metaRect.origin.y * originalSize.height, width: metaRect.size.width * originalSize.width, height: metaRect.size.height * originalSize.height).integral
        
        if let finalCgImage = originalImage.cgImage?.cropping(to: cropRect) {
            let image = UIImage(cgImage: finalCgImage, scale: 1.0, orientation: originalImage.imageOrientation)
//            self.imageView.image = image
            
            return image
        }
        
        return nil
    }
    
    private func updateImageView(with image: UIImage, isPreview: Bool, andIndex index: Int) {
        
        btnPhoto.isEnabled = false
        
        let orientation = UIApplication.shared.statusBarOrientation
        var scaledImageWidth: CGFloat = 0.0
        var scaledImageHeight: CGFloat = 0.0
        
        var tmpView: UIView = UIImageView()
        if isPreview{
            tmpView = previewPhoto
        }
        else{
            tmpView = imageView
        }
        
        
        switch orientation {
        case .portrait, .portraitUpsideDown, .unknown:
            scaledImageWidth = tmpView.bounds.size.width
            scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
        case .landscapeLeft, .landscapeRight:
            scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
            scaledImageHeight = tmpView.bounds.size.height
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
            var scaledImage = image.scaledImage(
                with: CGSize(width: scaledImageWidth, height: scaledImageHeight)
            )
            scaledImage = scaledImage ?? image
            guard let finalImage = scaledImage else { return }
            DispatchQueue.main.async {
                if isPreview{
                    self.previewPhoto.image = finalImage
                    
                }
                else{
//                    self.imageView.image = finalImage
                    self.detectTextFrom(finalImage, andIndex: index)
                    self.btnPhoto.isEnabled = true
                }
            }
        }
    }
}

//MARK: - MLVision
extension CustomCameraViewController{
    func detectTextFrom(_ image: UIImage, andIndex index: Int){
        var result = ""
        
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
                
                for line in block.lines {
                    result.append(line.text + "\n")
                    
                    print("Line: \(line.text)")
                    lines.append(line.text)
                }
            }
            
            self.dic[index] = lines
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

//MARK: - ZX Funcionalidad
extension CustomCameraViewController{
    func ZXSetup(){
        sessionZXQueue.async {
            self.isScanning = false
            self.isFirstApplyOrientation = false
            
            self.capture = ZXCapture()
            
            guard let _capture = self.capture else { return }
            
            _capture.camera = _capture.back()
            _capture.focusMode =  .continuousAutoFocus
            _capture.delegate = self
            
            guard let _scanView = self.scanView else { return }
            
            DispatchQueue.main.async {
                self.previewView.layer.addSublayer(_capture.layer)
                self.previewView.bringSubviewToFront(_scanView)
                
                let orientation = UIApplication.shared.statusBarOrientation
                var captureRotation: Double
                var scanRectRotation: Double
                
                switch orientation {
                case .portrait:
                    captureRotation = 0
                    scanRectRotation = 90
                    break
                    
                case .landscapeLeft:
                    captureRotation = 90
                    scanRectRotation = 180
                    break
                    
                case .landscapeRight:
                    captureRotation = 270
                    scanRectRotation = 0
                    break
                    
                case .portraitUpsideDown:
                    captureRotation = 180
                    scanRectRotation = 270
                    break
                    
                default:
                    captureRotation = 0
                    scanRectRotation = 90
                    break
                }
                
                self.applyRectOfInterest(orientation: orientation)
                
                let angleRadius = captureRotation / 180.0 * Double.pi
                let captureTranform = CGAffineTransform(rotationAngle: CGFloat(angleRadius))
                
                self.capture?.transform = captureTranform
                self.capture?.rotation = CGFloat(scanRectRotation)
                self.capture?.layer.frame = self.view.frame
                
                self.indicator.stopAnimating()
                self.indicator.isHidden = true

            }
            
            
            
            //        self.previewView.bringSubviewToFront(_resultLabel)
        }
    }
    
    func applyOrientation() {
        
        sessionZXQueue.async {
            DispatchQueue.main.async {
                let orientation = UIApplication.shared.statusBarOrientation
                var captureRotation: Double
                var scanRectRotation: Double
                
                switch orientation {
                case .portrait:
                    captureRotation = 0
                    scanRectRotation = 90
                    break
                    
                case .landscapeLeft:
                    captureRotation = 90
                    scanRectRotation = 180
                    break
                    
                case .landscapeRight:
                    captureRotation = 270
                    scanRectRotation = 0
                    break
                    
                case .portraitUpsideDown:
                    captureRotation = 180
                    scanRectRotation = 270
                    break
                    
                default:
                    captureRotation = 0
                    scanRectRotation = 90
                    break
                }
                
                self.applyRectOfInterest(orientation: orientation)
                
                let angleRadius = captureRotation / 180.0 * Double.pi
                let captureTranform = CGAffineTransform(rotationAngle: CGFloat(angleRadius))
                
                self.capture?.transform = captureTranform
                self.capture?.rotation = CGFloat(scanRectRotation)
                self.capture?.layer.frame = self.view.frame
            }
        }
    }
    
    func applyRectOfInterest(orientation: UIInterfaceOrientation) {
        guard var transformedVideoRect = scanView?.frame,
            let cameraSessionPreset = capture?.sessionPreset
            else { return }
        
        var scaleVideoX, scaleVideoY: CGFloat
        var videoHeight, videoWidth: CGFloat
        
        // Currently support only for 1920x1080 || 1280x720
        if cameraSessionPreset == AVCaptureSession.Preset.hd1920x1080.rawValue {
            videoHeight = 720.0
            videoWidth = 1280.0
        } else {
            videoHeight = 720.0
            videoWidth = 1280.0
        }
        
        if orientation == UIInterfaceOrientation.portrait {
            scaleVideoX = self.view.frame.width / videoHeight
            scaleVideoY = self.view.frame.height / videoWidth
            
            // Convert CGPoint under portrait mode to map with orientation of image
            // because the image will be cropped before rotate
            // reference: https://github.com/TheLevelUp/ZXingObjC/issues/222
            let realX = transformedVideoRect.origin.y;
            let realY = self.view.frame.size.width - transformedVideoRect.size.width - transformedVideoRect.origin.x;
            let realWidth = transformedVideoRect.size.height;
            let realHeight = transformedVideoRect.size.width;
            transformedVideoRect = CGRect(x: realX, y: realY, width: realWidth, height: realHeight);
            
        } else {
            scaleVideoX = self.view.frame.width / videoWidth
            scaleVideoY = self.view.frame.height / videoHeight
        }
        
        captureSizeTransform = CGAffineTransform(scaleX: 1.0/scaleVideoX, y: 1.0/scaleVideoY)
        guard let _captureSizeTransform = captureSizeTransform else { return }
        let transformRect = transformedVideoRect.applying(_captureSizeTransform)
        capture?.scanRect = transformRect
    }
    
    func barcodeFormatToString(format: ZXBarcodeFormat) -> String {
        switch (format) {
        case kBarcodeFormatAztec:
            return "Aztec"
            
        case kBarcodeFormatCodabar:
            return "CODABAR"
            
        case kBarcodeFormatCode39:
            return "Code 39"
            
        case kBarcodeFormatCode93:
            return "Code 93"
            
        case kBarcodeFormatCode128:
            return "Code 128"
            
        case kBarcodeFormatDataMatrix:
            return "Data Matrix"
            
        case kBarcodeFormatEan8:
            return "EAN-8"
            
        case kBarcodeFormatEan13:
            return "EAN-13"
            
        case kBarcodeFormatITF:
            return "ITF"
            
        case kBarcodeFormatPDF417:
            return "PDF417"
            
        case kBarcodeFormatQRCode:
            return "QR Code"
            
        case kBarcodeFormatRSS14:
            return "RSS 14"
            
        case kBarcodeFormatRSSExpanded:
            return "RSS Expanded"
            
        case kBarcodeFormatUPCA:
            return "UPCA"
            
        case kBarcodeFormatUPCE:
            return "UPCE"
            
        case kBarcodeFormatUPCEANExtension:
            return "UPC/EAN extension"
            
        default:
            return "Unknown"
        }
    }
}

//MARK: - ZXCaptureDelegate
extension CustomCameraViewController: ZXCaptureDelegate{
    func captureCameraIsReady(_ capture: ZXCapture!) {
        isScanning = true
    }
    
    func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        guard let _result = result, isScanning == true else { return }
        
        capture?.stop()
        isScanning = false
        let text = _result.text ?? "Unknow"
        let format = barcodeFormatToString(format: _result.barcodeFormat)
        
//        let displayStr = "Scanned !\nFormat: \(format)\nContents: \(text)"
        lblCodigoBarras.text = text
        codigoBarras = text
//        resultLabel?.text = displayStr
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

//        fase = .camara
//        DispatchQueue.main.async {
//            self.indicator.isHidden = false
//            self.indicator.startAnimating()
//            self.manejaFases()
//        }
        performSegue(withIdentifier: "TicketDetailSegue", sender: self)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
//            guard let weakSelf = self else { return }
//            weakSelf.isScanning = true
//            weakSelf.capture?.start()
//        }
    }
}

//MARK: - RESTActionDelegate
extension CustomCameraViewController: RESTActionDelegate{
    func restActionDidSuccessful(data: Data, identifier: String) {
        
        if identifier == ID_RQT_ANALIZAR{
            do{
                let decoder = JSONDecoder()
                
                let rsp = try decoder.decode(OCRResponse.self, from: data)
                if rsp.code == 200{
                    datosTicket = rsp
                    code = 200
                    print( "\(code)" )
                    print( "Requiere lectura de codigo de barras: \(rsp.tieneCB!)" )
                    fase = .escaner

                    if let tieneCB = rsp.tieneCB, tieneCB{
                        DispatchQueue.main.async {
                            self.indicator.isHidden = false
                            self.indicator.startAnimating()
                            self.manejaFases()
                        }
                    }
                    else{
                        performSegue(withIdentifier: "TicketDetailSegue", sender: self)
                    }
                }
                else if rsp.code == 203{
                    print("No existen productos")
                    code = 203
                    print( "\(code)" )
                    performSegue(withIdentifier: "ErrorTicketSegue", sender: self)
                }
                else{
                    print( "Error" )
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
        resetUICamara()
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

extension CustomCameraViewController: ErrorTicketViewControllerDelegate{
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

extension CustomCameraViewController: DetalleFotosViewControllerDelegate{
    func processPhotosViewController(_ controller: DetalleFotosViewController) {
        self.dismiss(animated: true, completion: nil)
        
        analizarOCRRequest()
    }
    
    func deletePhotosViewController(_ controller: DetalleFotosViewController) {
        self.dismiss(animated: true, completion: nil)
        resetUICamara()
    }
}
