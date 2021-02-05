//
//  SplashViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/23.
//

import UIKit

final class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func storyboardInstance() -> SplashViewController? {
        let storyboard = UIStoryboard(name: SplashViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
}
