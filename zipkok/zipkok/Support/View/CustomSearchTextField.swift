//
//  CustomSearchTextField.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit

@IBDesignable
open class CustomSearchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        frame = CGRect(x: 0, y: 0, width: 327, height: 56)
        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    }
}
