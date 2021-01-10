//
//  MainViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit

class MainViewController: UIViewController {

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
}
