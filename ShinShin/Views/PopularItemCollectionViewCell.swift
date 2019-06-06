//
//  PupularItemCollectionViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/5/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PopularItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblContenido: UILabel!
    @IBOutlet weak var view: UIView!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        view.layer.cornerRadius = 5.0
//    }
    
    override func awakeFromNib() {
        view.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
