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
        guard let loginVc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as? LoginViewController else {
            fatalError()
        }
        loginVc.modalPresentationStyle = .fullScreen
        present(loginVc, animated: false)
    }
    
    @IBAction func locationButtonTapped() {
        guard let loginVc = UIStoryboard(name: "Location", bundle: nil).instantiateInitialViewController() as? LocationViewController else {
            fatalError()
        }
        loginVc.modalPresentationStyle = .fullScreen
        present(loginVc, animated: false)
    }
}
