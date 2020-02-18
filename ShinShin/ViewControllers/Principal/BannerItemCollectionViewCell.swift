//
//  BannerItemCollectionViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/5/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BannerItemCollectionViewCell: UICollectionViewCell {
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var lblBaner: UILabel!
    @IBOutlet weak var lblContenido: UILabel!
    @IBOutlet weak var lblBonificacion: UILabelBonificacion!
    @IBOutlet weak var btnMasInfo: UIButton!
    @IBOutlet weak var btnMasInfoBig: UIButton!
    @IBOutlet weak var btnMasInfoBig2: UIButton!
    @IBOutlet weak var imageViewBanner: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var viewBannerLeft: UIView!
    
    override func awakeFromNib() {
        viewMain.layer.cornerRadius = 10.0
        viewBanner.layer.cornerRadius = 10.0
        btnMasInfo.layer.cornerRadius = 10.0
        btnMasInfo.alpha = 0.9
        btnMasInfo.setTitleColor(.white, for: .normal)
//        lblBonificacion.layer.masksToBounds = true
//        lblBonificacion.layer.cornerRadius = 10.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configure(url: String?){
        imageViewBanner.image = UIImage(named: "bonafont")
        
        if let url = url{
            if let imageURL = URL(string: url){
                downloadTask = imageViewBanner.loadImage(url: imageURL)
            }
        }
    }
    
}
