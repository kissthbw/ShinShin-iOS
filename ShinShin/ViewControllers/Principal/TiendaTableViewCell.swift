//
//  TiendaTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/11/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class TiendaTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var list = [CatalogoTiendas](){
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

extension TiendaTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TiendaItemCell", for: indexPath) as! TiendaItemCollectionViewCell
        
//        cell.lblDepto.text = "Producto"
        if indexPath.row == 0{
            cell.imageView.image = UIImage(named:"Oxxo")
        }
        if indexPath.row == 1{
            cell.imageView.image = UIImage(named:"7eleven")
        }
        if indexPath.row == 2{
            cell.imageView.image = UIImage(named:"Walmart")
        }
        
        
        return cell
    }
}

//extension TiendaTableViewCell: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let noOfCellsInRow = 3
//        
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        
//        let totalSpace = flowLayout.sectionInset.left
//            + flowLayout.sectionInset.right
//            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//        
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
//        
//        return CGSize(width: size, height: size) 
//    }
//}
