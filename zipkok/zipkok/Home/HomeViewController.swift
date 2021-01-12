//
//  HomeViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var startButtonView: UIView!
    @IBOutlet private weak var iconTextLabel: UILabel!
    
    @IBOutlet private weak var profileBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var settingBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStartButtonView()
        prepareIconTextLabel()
        prepareBarButtonItems()
    }
    
    private func prepareIconTextLabel() {
        iconTextLabel.transform = CGAffineTransform(rotationAngle: -(.pi/8))
    }
    
    private func prepareStartButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startButtonViewTapped))
        startButtonView.isUserInteractionEnabled = true
        startButtonView.addGestureRecognizer(tapGesture)
        
        startButtonView.layer.masksToBounds = false
        startButtonView.layer.cornerRadius = 8
        startButtonView.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        startButtonView.layer.shadowOffset = CGSize(width: 0, height: 12)
        startButtonView.layer.shadowOpacity = 0.25
        startButtonView.layer.shadowRadius = 14
    }
    
    private func prepareBarButtonItems() {
        profileBarButtonItem.image = UIImage(named: "그룹 114")?.withRenderingMode(.alwaysOriginal)
        shareBarButtonItem.image = UIImage(named: "그룹 116")?.withRenderingMode(.alwaysOriginal)
        settingBarButtonItem.image = UIImage(named: "그룹 113")?.withRenderingMode(.alwaysOriginal)
    }
    
    @IBAction func settingBarButtonItemTapped(_ sender: UIBarButtonItem) {
        guard let settingVc = UIStoryboard(name: "Setting", bundle: nil).instantiateInitialViewController() as? SettingViewController else {
            fatalError()
        }
        
        navigationController?.pushViewController(settingVc, animated: true)
    }
    
    @objc private func startButtonViewTapped() {
        guard let timerSettingVc = UIStoryboard(name: "TimerSetting", bundle: nil).instantiateInitialViewController() as? TimerSettingViewController else { fatalError() }
        
        addChild(timerSettingVc)
        view.addSubview(timerSettingVc.view)
        timerSettingVc.didMove(toParent: self)
    }
}
