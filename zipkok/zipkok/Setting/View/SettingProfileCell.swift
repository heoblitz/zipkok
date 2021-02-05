//
//  SettingProfileCell.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

final class SettingProfileCell: UITableViewCell {

    @IBOutlet weak var resetButtonLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLocationNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setComponetsStyle()
    }
    
    private func setComponetsStyle() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "재설정", attributes: underlineAttribute)
        resetButtonLabel.attributedText = underlineAttributedString
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: addressTextField.frame.height))
        addressTextField.leftView = paddingView
        addressTextField.leftViewMode = .always
    }
    
    func prepare(by userInfo: UserInfoResult) {
        addressTextField.text = userInfo.addressName
        userNameLabel.text = userInfo.userName
    }
}
