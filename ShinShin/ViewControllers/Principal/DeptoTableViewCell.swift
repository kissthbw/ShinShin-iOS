//
//  DeptoTableViewCell.swift
//  ShinShin
//
//  Created by Juan Osorio Alvarez on 6/5/19.
//  Copyright © 2019 Juan Osorio Alvarez. All rights reserved.
//

import UIKit

protocol DeptoTableViewDelegate: class{
    func selectedItem(_ controller: UITableViewCell, item: CatalogoDepartamentos)
}

class DeptoTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = -1
    var delegate: DeptoTableViewDelegate? //Definido en CategoriaTebleViewCell
    
    var list = [CatalogoDepartamentos](){
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

    }

}

extension DeptoTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedItem(self, item: list[indexPath.row])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeptoItemCell", for: indexPath) as! DeptoItemCollectionViewCell
        
        cell.lblDepto.text = list[indexPath.row].nombreTipoProducto
        cell.image.image = UIImage(named: "belleza")
        
        return cell
    }
}
