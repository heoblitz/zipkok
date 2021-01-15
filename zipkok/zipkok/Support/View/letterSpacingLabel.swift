//
//  letterSpacingLabel.swift
//  zipkok
//
//  Created by won heo on 2021/01/15.
//

import UIKit

open class letterSpacingLabel: UILabel {
    @IBInspectable open var characterSpacing:CGFloat = 1 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: self.characterSpacing, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
}
