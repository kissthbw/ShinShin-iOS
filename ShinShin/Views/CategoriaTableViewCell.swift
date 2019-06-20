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
        cell.viewMain.backgroundColor = UIColor(red: 0.0/255.0, green: 131.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        cell.viewBanner.backgroundColor  = UIColor(red: 0.0/255.0, green: 121.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        cell.viewBannerLeft.backgroundColor  = UIColor(red: 0.0/255.0, green: 121.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        cell.lblBaner.text = "Banner \(indexPath.section) \(indexPath.row)"
        cell.lblContenido.text = "600 ml"
        cell.btnMasInfo.tag = indexPath.row
        cell.btnMasInfo.addTarget(self, action: #selector(selectedItem(sender:)), for: .touchUpInside)
        cell.btnMasInfo.backgroundColor  = UIColor(red: 0.0/255.0, green: 121.0/255.0, blue: 77.0/255.0, alpha: 1.0)
        
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
