//
//  CustomAlertView.swift
//  zipkok
//
//  Created by won heo on 2021/01/21.
//

import UIKit

final class CustomAlertView: UIView {
    @IBOutlet weak var alertContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    static func loadViewFromNib() -> CustomAlertView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "CustomAlertView", bundle: bundle)
        let customView = nib.instantiate(withOwner: nil, options: nil).first as! CustomAlertView
        customView.prepareComponents()
        return customView
    }
    
    private func prepareComponents() {
        alertContentView.layer.masksToBounds = false
        alertContentView.layer.cornerRadius = 8
    }
    
    @IBAction func dismissButtonTapped() {
        removeFromSuperview()
    }
}
