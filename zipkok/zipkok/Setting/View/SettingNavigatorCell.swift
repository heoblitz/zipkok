//
//  SettingNavigatorCell.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

final class SettingNavigatorCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    let pushSwitchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.setImage(UIImage(named: "그룹 1429"), for: .selected)
        button.setImage(UIImage(named: "그룹 1433"), for: .normal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepareSwitchButton() {
        contentView.addSubview(pushSwitchButton)
        
        NSLayoutConstraint.activate([
            pushSwitchButton.widthAnchor.constraint(equalToConstant: 65),
            pushSwitchButton.heightAnchor.constraint(equalToConstant: 30),
            pushSwitchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pushSwitchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
}
