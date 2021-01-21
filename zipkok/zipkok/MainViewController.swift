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
    
    @IBAction func testVcButtonTapped() {
        guard let testVc = UIStoryboard(name: "Test", bundle: nil).instantiateInitialViewController() as? TestViewController else {
            fatalError()
        }
        
        testVc.modalPresentationStyle = .fullScreen
        present(testVc, animated: false)
    }
}
