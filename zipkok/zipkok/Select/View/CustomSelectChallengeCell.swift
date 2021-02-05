//
//  CustomSelectChallengeCell.swift
//  zipkok
//
//  Created by won heo on 2021/01/20.
//

import UIKit

final class CustomSelectChallengeCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = false
        layer.cornerRadius = 15
        layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 5
    }

}
