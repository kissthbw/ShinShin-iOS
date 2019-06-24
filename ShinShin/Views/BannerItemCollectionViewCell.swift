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
    @IBOutlet weak var lblBonificacion: UILabel!
    @IBOutlet weak var btnMasInfo: UIButton!
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
        lblBonificacion.layer.masksToBounds = true
        lblBonificacion.layer.cornerRadius = 10.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configure(){
//        imageViewBanner.image = UIImage(named: "producto_detail_placeholder")
//        if let imageURL = URL(string: "https://res.cloudinary.com/shingshing/image/upload/v1561175238/shingshing/heart_zlmhw6.png"){
//            downloadTask = imageViewBanner.loadImage(url: imageURL)
//        }
//        nameLabel.text! = result.name
//
//        if result.name.isEmpty{
//            artistNameLabel.text! = "Unknown"
//        }
//        else{
//            artistNameLabel.text! = String(format: "%@ (%@)", result.artist, result.type)
//        }
//
//        artworkImageView.image = UIImage(named: "Placeholder")
//        if let smallUrl = URL(string: result.imageSmall){
//            downloadTask = artworkImageView.loadImage(url: smallUrl)
//        }
        
    }
    
}
