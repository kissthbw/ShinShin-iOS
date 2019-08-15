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

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var switchFase: UISwitch!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var controlesCamaraView: UIView!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblCodigoBarras: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var previewPhoto: UIImageView!
    @IBOutlet weak var lblCountPhotos: UILabel!
    @IBOutlet weak var btnBorrar: UIButton!
    @IBOutlet weak var btnOmitir: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    
    lazy var vision = Vision.vision()
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var codigoBarras: String?
    var photos: [UIImage] = [UIImage]()
    var dic = [Int: [String]]()
    var code = -1
    var datosTicket = OCRResponse()
    var visiblePreview = false
    
    let ID_RQT_ANALIZAR = "ID_RQT_ANALIZAR"
    
    //MARK: - Enum para manejo de estados
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
    }
    
    //Este metodo es llamada cada vez que los limites del view del
    //ViewController cambia, es responsabilidad del programador hacer los
    //ajustes necesarios en cada elemento
    override func viewDidLayoutSubviews(){
        //El cambio sólo debe aplicar cuando esta habilitado el modo
        //de escaneo
//        switchFase.isHidden = true
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fase = .camara
        switchFase.isHidden = true
        visiblePreview = false
        photos = [UIImage]()
        
        if fase == .camara{
            setupCaptureSession()
        }
        else if( fase == .escaner ){
            ZXSetup()
        }
        
        lblCodigoBarras.text = ""
        lblCountPhotos.text = ""
        previewPhoto.image = nil
        codigoBarras = ""
        
        initUIElements()
        
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        print("Cerrando configuracion de camara")
        if fase == .camara{
            self.captureSession.stopRunning()
        }
        else if fase == .escaner{
            capture?.stop()
            isScanning = false
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        delegate?.didCompletedTakePhoto(self, withPhotos: photos, and: codigoBarras)
        if segue.identifier == "DetalleFotoSegue"{
            let vc = segue.destination as! OCRViewController
            vc.photos = photos
            vc.codeBar = codigoBarras
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
    
    //MARK: - Actions
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        settings.isAutoStillImageStabilizationEnabled =
//            self.stillImageOutput.isStillImageStabilizationSupported
//        if settings.availablePreviewPhotoPixelFormatTypes.count > 0 {
//            print("Preview")
//            settings.previewPhotoFormat = [
//                kCVPixelBufferPixelFormatTypeKey : settings.availablePreviewPhotoPixelFormatTypes.first!,
//                kCVPixelBufferWidthKey : 512,
//                kCVPixelBufferHeightKey : 512
//                ] as [String: Any]
//        }
        
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func cerrar(_ sender: Any) {
        if fase == .camara{
            self.captureSession.stopRunning()
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
    
    @IBAction func changeFase(_ sender: Any) {
        
        if switchFase.isOn{
            fase = .escaner
        }
        else{
            fase = .camara
        }
        
        DispatchQueue.main.async {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.manejaFases()
        }
    }
    
    @IBAction func OKAction(_ sender: Any) {
//        delegate?.didCompletedTakePhoto(self, withPhotos: photos, and: codigoBarras)
//        performSegue(withIdentifier: "DetalleFotoSegue", sender: self)
//        for (index, photo) in photos.enumerated() {
//            updateImageView(with: photo, isPreview: false, andIndex: index)
//        }
        analizarOCRRequest()
    }
    
    @IBAction func DELETEAction(_ sender: Any) {
        
        photos = [UIImage]()
        dic = [Int: [String]]()
        visiblePreview = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.previewPhoto.alpha = 0.0
            self.lblCountPhotos.alpha = 0.0
            self.btnOk.alpha = 0.0
            self.btnOk.isEnabled = false
            self.btnBorrar.alpha = 0.0
            self.btnBorrar.isEnabled = false
        }) { (Bool) in
            self.previewPhoto.image = nil
            self.lblCountPhotos.text = ""
        }
    }
    
    @IBAction func OMITIRAction(_ sender: Any) {
        performSegue(withIdentifier: "TicketDetailSegue", sender: self)
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
    
    //MARK: - Animation methods
    func manejaFases(){
        var alpha: CGFloat  = 1.0
        var bottomConstant: CGFloat = 0.0
        self.previewView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        if fase == .escaner{
            alpha = 1.0
            bottomConstant = 150.0
            captureSession.stopRunning()
            ZXSetup()
        }
        else{
            alpha = 0.0
            bottomConstant = 0.0
            //[self.capture.layer removeFromSuperlayer];
            self.capture?.layer.removeFromSuperlayer()
            capture?.stop()
            isScanning = false
            setupCaptureSession()
        }
        
//        DispatchQueue.main.async {
//            self.indicator.stopAnimating()
////            self.indicator.isHidden = true
//        }
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.scanView?.alpha = alpha
                        self.btnOmitir.alpha = alpha
                        self.btnOmitir.isEnabled = true
                        },
                       completion: nil)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5.0,
                       options: [.curveEaseIn],
                       animations: {
                        self.bottomConstraint.constant = bottomConstant
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                        },
                       completion: nil)
    }
    
    //MARK: - Helper methods
    func setupCaptureSession(){
        sessionQueue.sync {
            captureSession = AVCaptureSession()
            
            self.captureSession.beginConfiguration()
            self.captureSession.sessionPreset = .high

            
            guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
                else {
                    print("Unable to access back camera!")
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
    
    func initUIElements(){
        //De acuerdo al flujo deben esar deshabilitados los componentes
        //referentes a la captura de codigo de barras o la camara
        //
        indicator.isHidden = true
        lblCodigoBarras.text = ""
        if fase == .camara{
            btnOk.alpha = 0.0
            btnOk.isEnabled = false
            btnOmitir.alpha = 0.0
            btnOmitir.isEnabled = false
            btnBorrar.alpha = 0.0
            btnBorrar.isEnabled = false
            switchFase.isOn = false
            scanView?.isHidden = false
            scanView?.alpha = 0.0
            bottomConstraint.constant = 0.0
        }
        else if fase == .escaner{
            switchFase.isOn = true
            scanView?.isHidden = false
            scanView?.alpha = 1.0
            bottomConstraint.constant = 150.0
        }
    }
}

extension CustomCameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        
        if let image = image{
            photos.append(image)
            //Si los lblCountPhotos y previewPhoto estan ocultos se deben mostrar
            if !visiblePreview{
                UIView.animate(withDuration: 0.5, animations: {
                    self.btnOk.alpha = 1.0
                    self.btnOk.isEnabled = true
                    self.btnBorrar.alpha = 1.0
                    self.btnBorrar.isEnabled = true
                    self.previewPhoto.alpha = 1.0
                    self.lblCountPhotos.alpha = 1.0
                }, completion: nil)
                
                visiblePreview = !visiblePreview
            }
            
            lblCountPhotos.text = String("\(photos.count)")

            updateImageView(with: image, isPreview: true, andIndex: 0)
            updateImageView(with: image, isPreview: false, andIndex: 0)
        }

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
