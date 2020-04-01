//
//  DetalleFotosViewController.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 9/18/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol DetalleFotosViewControllerDelegate: class{
    func processPhotosViewController(_ controller: DetalleFotosViewController)
    func deletePhotosViewController(_ controller: DetalleFotosViewController)
}

class DetalleFotosViewController: UIViewController {

    var photos: [UIImage] = [UIImage]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnAgregar: UIButton!
    @IBOutlet weak var btnListo: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    
    weak var delegate: DetalleFotosViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEliminar.layer.borderColor = UIColor(red: 255/255, green: 111/255, blue: 0/255, alpha: 1.0).cgColor
        btnEliminar.layer.borderWidth = 1.0
        btnEliminar.layer.cornerRadius = 5.0
        
        btnAgregar.layer.cornerRadius = 10.0
        btnListo.layer.cornerRadius = 10.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initUI()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - UI Actions
    @IBAction func back(_ sender: Any) {
        Model.mantenerCamara = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhotoAction(_ sender: Any) {
        Model.mantenerCamara = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func readyAction(_ sender: Any) {
        //Debe cerrar esta pantalla
        //LLamar la action de procesar fotos
        Model.mantenerCamara = true
        delegate?.processPhotosViewController(self)
    }
    
    @IBAction func deletePhotosAction(_ sender: Any) {
        Model.mantenerCamara = true
        delegate?.deletePhotosViewController(self)
    }
    
    //MARK: - Helper methods
    func initUI(){
        
        let frame = scrollView.frame
        let total: CGFloat = CGFloat(photos.count)
        let width = frame.width * total
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize.width = width + (total * 20)
        
        var padding: CGFloat = 0
        for (index, photo) in photos.enumerated(){
            print("Foto: \(index)")
            let tmp = UIImageView()
            tmp.contentMode = .scaleAspectFit
            tmp.image = photo
            let tmpFrame = CGRect(x: (frame.width * CGFloat(index) + padding), y: 0, width: frame.width - 10, height: frame.height)
            tmp.frame = tmpFrame
            tmp.layer.borderWidth = 2
            tmp.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
            tmp.layer.cornerRadius = 10.0
            tmp.clipsToBounds = true
            padding = 10
            scrollView.addSubview(tmp)
        }

        
//        imagePreview.frame = CGRect(x: imagePreview.frame.width, y: 0, width: imagePreview.frame.width, height: imagePreview.frame.height)
//        scrollView.addSubview(imagePreview)
//        scrollView.addSubview(imagePreview)
    }
}

//MARK: - Extensions
extension DetalleFotosViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        print("Estas viendo la foto: \(pageNumber)")
//        pageControl.currentPage = Int(pageNumber)
    }
}
