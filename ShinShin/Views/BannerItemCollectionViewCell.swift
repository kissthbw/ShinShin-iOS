//
//  BannerItemCollectionViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/5/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class BannerItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblBaner: UILabel!
    @IBOutlet weak var lblContenido: UILabel!
    @IBOutlet weak var lblBonificacion: UILabel!
    @IBOutlet weak var btnMasInfo: UIButton!
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
}
