//
//  LocationAlertView.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit

class ChallengeQuitAlertView: UIView {
    @IBOutlet weak var alertContentView: UIView!
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var quitButtonView: UIView!
    
    static func loadViewFromNib() -> ChallengeQuitAlertView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "ChallengeQuitAlertView", bundle: bundle)
        let locationView = nib.instantiate(withOwner: nil, options: nil).first as! ChallengeQuitAlertView
        locationView.prepareComponents()
        return locationView
    }
    
    private func prepareComponents() {
        alertContentView.layer.masksToBounds = false
        alertContentView.layer.cornerRadius = 8
        
        cancelButtonView.layer.masksToBounds = false
        cancelButtonView.layer.cornerRadius = 8
        cancelButtonView.layer.borderWidth = 1
        cancelButtonView.layer.borderColor = CGColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
        
        quitButtonView.layer.masksToBounds = false
        quitButtonView.layer.cornerRadius = 8
        quitButtonView.layer.borderWidth = 1
        quitButtonView.layer.borderColor = CGColor(red: 255/255, green: 105/255, blue: 28/255, alpha: 1)
    }
}
