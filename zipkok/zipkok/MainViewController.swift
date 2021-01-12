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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped() {
        guard let loginNavVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? UINavigationController else {
            fatalError()
        }
        loginNavVc.modalPresentationStyle = .fullScreen
        present(loginNavVc, animated: false)
    }
    
    @IBAction func locationButtonTapped() {
        guard let locationVc = UIStoryboard(name: "Location", bundle: nil).instantiateInitialViewController() as? LocationViewController else {
            fatalError()
        }
        locationVc.modalPresentationStyle = .fullScreen
        present(locationVc, animated: false)
    }
    
    @IBAction func locationWebButtonTapped() {
        guard let locationWebVc = UIStoryboard(name: "LocationWeb", bundle: nil).instantiateInitialViewController() as? LocationWebViewController else {
            fatalError()
        }
        // loginVc.modalPresentationStyle = .fullScreen
        present(locationWebVc, animated: false)
    }
    
    @IBAction func homeButtonTapped() {
        guard let homeVc = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as? UINavigationController else { fatalError() }
        
        homeVc.modalPresentationStyle = .fullScreen
        present(homeVc, animated: true)
    }
    
    @IBAction func alertButtonTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cacelButtonTapped))
        alertView.cancelButtonView.isUserInteractionEnabled = true
        alertView.cancelButtonView.addGestureRecognizer(tapGesture)
        view.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            alertView.topAnchor.constraint(equalTo: view.topAnchor),
            alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @IBAction func alertShareButtonTapped() {
        let share = ChallengeSuccessAlertView.loadViewFromNib()
        share.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(share)
        
        NSLayoutConstraint.activate([
            share.topAnchor.constraint(equalTo: view.topAnchor),
            share.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            share.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            share.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func cacelButtonTapped() {
        alertView.removeFromSuperview()
    }
}
