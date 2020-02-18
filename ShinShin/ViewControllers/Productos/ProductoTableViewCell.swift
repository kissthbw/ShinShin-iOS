//
//  ProductoTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/6/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class ProductoTableViewCell: UITableViewCell {
    var downloadTask: URLSessionDownloadTask?
    @IBOutlet weak var imageProducto: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblContenido: UILabel!
    @IBOutlet weak var btnMasInfo: UIButton!
    @IBOutlet weak var lblBonificacion: UILabelBonificacion!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        lblBonificacion.layer.masksToBounds = true
//        lblBonificacion.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configure(item: Producto, index: Int){
        lblNombre.text = item.nombreProducto
        lblContenido.text = item.contenido
        btnMasInfo.tag = index
        imageProducto.image = nil
        if let url = item.imgUrl{
            if let imageURL = URL(string: url){
                downloadTask = imageProducto.loadImage(url: imageURL)
            }
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let tmp = NSNumber(value: item.cantidadBonificacion!)
        if let bon = formatter.string(from: tmp){
            lblBonificacion.text = "$ \(bon)"
        }
    }
}
