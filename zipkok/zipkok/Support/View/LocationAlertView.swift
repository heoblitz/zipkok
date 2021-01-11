//
//  LocationAlertView.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit

class LocationAlertView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nib = UINib(nibName: "LocationAlertView", bundle: Bundle.main)
        
        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
