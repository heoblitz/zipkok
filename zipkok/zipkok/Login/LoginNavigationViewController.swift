//
//  LoginNavigationViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/10.
//

import UIKit

class LoginNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        prepareNavigationBar()
    }
    
    private func prepareNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "Backward arrow")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -20, bottom: -3, right: 0))
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "Backward arrow")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -20, bottom: -3, right: 0))
    }
}

extension LoginNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
