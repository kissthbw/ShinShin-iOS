//
//  PupularItemCollectionViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/5/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PopularItemCollectionViewCell: UICollectionViewCell {
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblContenido: UILabel!
    @IBOutlet weak var lblBonificacion: UILabelBonificacion!
    @IBOutlet weak var btnMasInfo: UIButton!
    @IBOutlet weak var btnMasInfo2: UIButton!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var img: UIImageView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        view.layer.cornerRadius = 5.0
//    }
    
    override func awakeFromNib() {
        view.layer.cornerRadius = 10.0
//        lblBonificacion.layer.masksToBounds = true
//        lblBonificacion.layer.cornerRadius = 10.0
        btnMasInfo.layer.cornerRadius = 10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configure(url: String?){
        img.image = UIImage(named: "producto_detail_placeholder")
        
        if let url = url{
            if let imageURL = URL(string: url){
                downloadTask = img.loadImage(url: imageURL)
            }
        }
    }
}
