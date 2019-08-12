//
//  BarCodeViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 7/24/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit
import ZXingObjC

class BarCodeViewController: UIViewController {

    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var scanView: UIView?
    @IBOutlet weak var resultLabel: UILabel?
    
    fileprivate var capture: ZXCapture?
    fileprivate var isScanning: Bool?
    fileprivate var isFirstApplyOrientation: Bool?
    fileprivate var captureSizeTransform: CGAffineTransform?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decodeImage()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstApplyOrientation == true { return }
        isFirstApplyOrientation = true
        applyOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            // do nothing
        }) { [weak self] (context) in
            guard let weakSelf = self else { return }
            weakSelf.applyOrientation()
        }
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

extension BarCodeViewController{
    func setup(){
        isScanning = false
        isFirstApplyOrientation = false
        
        capture = ZXCapture()
        
        guard let _capture = capture else { return }
        
        
        _capture.camera = _capture.back()
        _capture.focusMode =  .continuousAutoFocus
        _capture.delegate = self
        
        self.previewView.layer.addSublayer(_capture.layer)
        guard let _scanView = scanView, let _resultLabel = resultLabel else { return }
        self.previewView.bringSubviewToFront(_scanView)
        self.previewView.bringSubviewToFront(_resultLabel)
    }
    
    func applyOrientation() {
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
        
        applyRectOfInterest(orientation: orientation)
        
        let angleRadius = captureRotation / 180.0 * Double.pi
        let captureTranform = CGAffineTransform(rotationAngle: CGFloat(angleRadius))
        
        capture?.transform = captureTranform
        capture?.rotation = CGFloat(scanRectRotation)
        capture?.layer.frame = self.previewView.frame
    }
    
    func applyRectOfInterest(orientation: UIInterfaceOrientation) {
        guard var transformedVideoRect = scanView?.frame,
            let cameraSessionPreset = capture?.sessionPreset
            else { return }
        
        var scaleVideoX, scaleVideoY: CGFloat
        var videoHeight, videoWidth: CGFloat
        
        // Currently support only for 1920x1080 || 1280x720
        if cameraSessionPreset == AVCaptureSession.Preset.hd1920x1080.rawValue {
            videoHeight = 1080.0
            videoWidth = 1920.0
        } else {
            videoHeight = 720.0
            videoWidth = 1280.0
        }
        
        if orientation == UIInterfaceOrientation.portrait {
            scaleVideoX = self.previewView.frame.width / videoHeight
            scaleVideoY = self.previewView.frame.height / videoWidth
            
            // Convert CGPoint under portrait mode to map with orientation of image
            // because the image will be cropped before rotate
            // reference: https://github.com/TheLevelUp/ZXingObjC/issues/222
            let realX = transformedVideoRect.origin.y;
            let realY = self.previewView.frame.size.width - transformedVideoRect.size.width - transformedVideoRect.origin.x;
            let realWidth = transformedVideoRect.size.height;
            let realHeight = transformedVideoRect.size.width;
            transformedVideoRect = CGRect(x: realX, y: realY, width: realWidth, height: realHeight);
            
        } else {
            scaleVideoX = self.previewView.frame.width / videoWidth
            scaleVideoY = self.previewView.frame.height / videoHeight
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
    
    func decodeImage(){
        let imageTest = UIImage(named: "Databar_Ampliado")
        let cgImage = imageTest?.cgImage
        
        let source = ZXCGImageLuminanceSource(cgImage: cgImage)
        let binarizer = ZXHybridBinarizer(source: source)
        let bitmap = ZXBinaryBitmap.init(binarizer: binarizer)
        
        let reader = ZXMultiFormatReader()
        do{
            let result = try reader.decode(bitmap)
            print("\(result.text)")
        }
        catch{
            print("Error al leer codigo de barras")
        }
    }
}

extension BarCodeViewController: ZXCaptureDelegate{
    func captureCameraIsReady(_ capture: ZXCapture!) {
        isScanning = true
    }
    
    func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        guard let _result = result, isScanning == true else { return }
        
        capture?.stop()
        isScanning = false
        
        let text = _result.text ?? "Unknow"
        let format = barcodeFormatToString(format: _result.barcodeFormat)
        
        let displayStr = "Scanned !\nFormat: \(format)\nContents: \(text)"
        print("\(displayStr)")
        resultLabel?.text = displayStr
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.isScanning = true
            weakSelf.capture?.start()
        }
    }
}
