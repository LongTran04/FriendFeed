//
//  CollectionViewCell.swift
//  FriendFeed
//
//  Created by Long Tran on 11/04/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 13
        layer.borderWidth = 1
        
    }
    
    func setUpCell() {
        backgroundColor = .systemGray6
        if !isSelected {
            layer.borderColor = UIColor.clear.cgColor
        }
        else {
            layer.borderColor = UIColor(red: 0.23, green: 0.71, blue: 0.48, alpha: 1.00).cgColor
        }
    }
    
    

}
