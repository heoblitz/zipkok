//
//  RecentLocationCell.swift
//  zipkok
//
//  Created by won heo on 2021/01/23.
//

import UIKit

final class RecentLocationCell: UITableViewCell {

    @IBOutlet private weak var parcelAddressLabel: UILabel!
    @IBOutlet private weak var streetAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(by location: RecentLocation) {
        parcelAddressLabel.text = location.parcelAddressing
        streetAddressLabel.text = location.streetAddressing
    }
}
