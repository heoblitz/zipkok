//
//  LoginViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var iconTextLabel: UILabel!
    @IBOutlet private weak var kakaoLoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareIconTextLabel()
        prepareKakaoLoginView()
    }
    
    func prepareIconTextLabel() {
        iconTextLabel.transform = CGAffineTransform(rotationAngle: -(.pi/8))
    }
    
    func prepareKakaoLoginView() {
        kakaoLoginView.layer.masksToBounds = false
        kakaoLoginView.layer.cornerRadius = 8
        kakaoLoginView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        kakaoLoginView.layer.shadowOffset = CGSize(width: 0, height: 12)
        kakaoLoginView.layer.shadowOpacity = 0.25
        kakaoLoginView.layer.shadowRadius = 14
    }
}
