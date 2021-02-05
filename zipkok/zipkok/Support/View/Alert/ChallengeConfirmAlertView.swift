//
//  ChallengeConfirmAlertView.swift
//  zipkok
//
//  Created by won heo on 2021/01/28.
//

import UIKit

final class ChallengeConfirmAlertView: UIView {
    
    @IBOutlet weak var alertContentView: UIView!
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var startButtonView: UIView!
    @IBOutlet weak var dayNumberLabel: UILabel!
    
    static func loadViewFromNib() -> ChallengeConfirmAlertView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "ChallengeConfirmAlertView", bundle: bundle)
        let customView = nib.instantiate(withOwner: nil, options: nil).first as! ChallengeConfirmAlertView
        customView.prepareComponents()
        return customView
    }
    
    private func prepareComponents() {
        alertContentView.layer.masksToBounds = false
        alertContentView.layer.cornerRadius = 8
        
        cancelButtonView.layer.masksToBounds = false
        cancelButtonView.layer.cornerRadius = 8
        cancelButtonView.layer.borderWidth = 1
        cancelButtonView.layer.borderColor = CGColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
        
        startButtonView.layer.masksToBounds = false
        startButtonView.layer.cornerRadius = 8
        startButtonView.layer.borderWidth = 1
        startButtonView.layer.borderColor = CGColor(red: 34/255, green: 145/255, blue: 255/255, alpha: 1)
    }
}
