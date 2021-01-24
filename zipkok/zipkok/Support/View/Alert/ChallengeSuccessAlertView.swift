//
//  ChallengeSuccessAlertView.swift
//  zipkok
//
//  Created by won heo on 2021/01/12.
//

import UIKit

class ChallengeSuccessAlertView: UIView {
    @IBOutlet weak var alertContentView: UIView!
    @IBOutlet weak var shareButtonView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    
    static func loadViewFromNib() -> ChallengeSuccessAlertView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "ChallengeSuccessAlertView", bundle: bundle)
        let locationView = nib.instantiate(withOwner: nil, options: nil).first as! ChallengeSuccessAlertView
        locationView.prepareComponents()
        return locationView
    }
    
    private func prepareComponents() {
        alertContentView.layer.masksToBounds = false
        alertContentView.layer.cornerRadius = 8

        shareButtonView.layer.masksToBounds = false
        shareButtonView.layer.cornerRadius = 8
        shareButtonView.layer.borderWidth = 1
        shareButtonView.layer.borderColor = CGColor(red: 34/255, green: 145/255, blue: 255/255, alpha: 1)
    }
}
