//
//  HomeNavigationViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

final class HomeNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        prepareNavigationBar()
    }
    
    static func storyboardInstance() -> HomeNavigationViewController? {
        let storyboard = UIStoryboard(name: HomeViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func prepareNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "Backward arrow")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -20, bottom: -3, right: 0))
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "Backward arrow")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -20, bottom: -3, right: 0))
    }
}

extension HomeNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
