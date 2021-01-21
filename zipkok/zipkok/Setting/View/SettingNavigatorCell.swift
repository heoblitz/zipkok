//
//  SettingNavigatorCell.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

class SettingNavigatorCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    let swtichButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.setImage(UIImage(named: "그룹 1429"), for: .selected)
        button.setImage(UIImage(named: "그룹 1433"), for: .normal)
        button.isSelected = true
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func prepareSwitchButton() {
        contentView.addSubview(swtichButton)
        
        NSLayoutConstraint.activate([
            swtichButton.widthAnchor.constraint(equalToConstant: 65),
            swtichButton.heightAnchor.constraint(equalToConstant: 30),
            swtichButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            swtichButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
}
