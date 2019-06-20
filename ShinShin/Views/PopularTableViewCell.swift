//
//  PopularTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/5/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

class PopularTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = -1
    var delegate: CollectionViewDelegate? //Definido en CategoriaTebleViewCell
    
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

extension PopularTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print( "\(list[indexPath.row].nombreProducto!)" )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularItemCell", for: indexPath) as! PopularItemCollectionViewCell
        
        cell.lblNombre.text = "Producto"
        cell.lblContenido.text = "600 ml"
        cell.btnMasInfo.tag = indexPath.row
        cell.btnMasInfo.addTarget(self, action: #selector(selectedItem(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc
    func selectedItem( sender: Any?){
        let btn = sender as! UIButton
        let index = btn.tag
        delegate?.selectedItem(self, item: list[index])
    }
}
