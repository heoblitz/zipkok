//
//  MainViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var alertView: ChallengeQuitAlertView = {
        let alert = ChallengeQuitAlertView.loadViewFromNib()
        alert.translatesAutoresizingMaskIntoConstraints = false
        return alert
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped() {
        guard let loginNavVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? UINavigationController else {
            fatalError()
        }
        loginNavVc.modalPresentationStyle = .fullScreen
        present(loginNavVc, animated: false)
    }
    
    @IBAction func homeButtonTapped() {
        guard let homeVc = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as? UINavigationController else { fatalError() }
        
        homeVc.modalPresentationStyle = .fullScreen
        present(homeVc, animated: true)
    }
    
    @IBAction func kakaoLoginTestButtonTapped() {
        guard let loginNavVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? UINavigationController else {
            fatalError()
        }
        loginNavVc.modalPresentationStyle = .fullScreen
        present(loginNavVc, animated: false)
    }

    @IBAction func requestCoordButtonTapped() {
        GeoCodingApi.shared.requestCoord(by: "석계로 49", completeHander: { x, y in
            print(x, y)
        })
    }
    
    @IBAction func requestRegioncode() {
        GeoCodingApi.shared.requestRegioncode(by: (37.6172252018111, 127.06253874566), completeHander: { addressName in
            print(addressName)
        })
    }
}
