//
//  CategoriaTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/4/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol CollectionViewDelegate: class{
    func selectedItem(_ controller: UITableViewCell, item: Producto)
}

class CategoriaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = -1
    var delegate: CollectionViewDelegate?
    
    var list = [Producto](){
        willSet{
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func configure(for result: SearchResult){
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
//
//    }

}


extension CategoriaTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print( "\(list[indexPath.row].nombreProducto!)" )
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! BannerItemCollectionViewCell
        
        let item = list[indexPath.row]
        cell.configure()
        if let color = item.colorBanner{
            let color = color.components(separatedBy: ",")
            
            let r = CGFloat(Float(color[0]) ?? 0.0)
            let g = CGFloat(Float(color[1]) ?? 0.0)
            let b = CGFloat(Float(color[2]) ?? 0.0)
            
            //Enviar a Robert
            cell.viewBannerLeft.backgroundColor  = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
            cell.viewBanner.backgroundColor  = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
            
            cell.viewMain.backgroundColor = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 0.8)
            
            cell.btnMasInfo.backgroundColor = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 0.8)
        }
//        let fullNameArr = fullName.components(separatedBy: " ")
        
//        cell.viewMain.backgroundColor = UIColor(red: 0.0/255.0, green: 131.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        
        
        cell.lblBaner.text = item.nombreProducto
        cell.lblContenido.text = item.contenido
        cell.lblBonificacion.text = Validations.formatWith(item.cantidadBonificacion)
        cell.btnMasInfoBig.tag = indexPath.row
        cell.btnMasInfo.tag = indexPath.row
        cell.btnMasInfo.addTarget(self, action: #selector(selectedItem(sender:)), for: .touchUpInside)
        cell.btnMasInfoBig.addTarget(self, action: #selector(selectedItem(sender:)), for: .touchUpInside)
        
        
        return cell
    }
    
    @objc
    func selectedItem( sender: Any?){
        let btn = sender as! UIButton
        let index = btn.tag
        delegate?.selectedItem(self, item: list[index])
    }
}

extension CategoriaTableViewCell: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow:CGFloat = 4
//        let hardCodedPadding:CGFloat = 5
//        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
//        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
}
