//
//  TimerSettingViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

class TimerSettingViewController: UIViewController {

    @IBOutlet private weak var startWithFriendButtonView: UIView!
    @IBOutlet private weak var startImageView: UIImageView!
    @IBOutlet private weak var startTimeView: UIView!
    @IBOutlet private weak var endTimeView: UIView!
    
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    
    private let keyChainManager = KeyChainManager()

    var dayNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareStartImageView()
        prepareStartWithFriendButtonView()
        prepareStartTimeView()
        prepareEndTimeView()
        setNavigationComponents()
        prepareNavigationBarItems()
    }
    
    static func storyboardInstance() -> TimerSettingViewController? {
        let storyboard = UIStoryboard(name: TimerSettingViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    
    private func prepareNavigationBarItems() {
//        let profileBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 114")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
//        profileBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 116")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        shareBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        let settingBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 113")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(settingBarButtonItemTapped))
        settingBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
//          navigationItem.leftBarButtonItem = profileBarButtonItem
        navigationItem.rightBarButtonItems = [settingBarButtonItem, shareBarButtonItem]
    }
    
    private func setNavigationComponents() {
        navigationItem.hidesBackButton = true
    }
    
    private func prepareStartImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startImageButtonTapped))
        startImageView.isUserInteractionEnabled = true
        startImageView.addGestureRecognizer(tapGesture)
    }
    
    private func prepareStartWithFriendButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startWithFriendButtonViewTapped))
        startWithFriendButtonView.addGestureRecognizer(tapGesture)
        startWithFriendButtonView.isUserInteractionEnabled = true
        
        startWithFriendButtonView.layer.masksToBounds = false
        startWithFriendButtonView.layer.cornerRadius = 8
        startWithFriendButtonView.layer.borderColor = CGColor(red: 62/255, green: 115/255, blue: 255/255, alpha: 1)
        startWithFriendButtonView.layer.borderWidth = 1
    }

    private func prepareStartTimeView() {
        startTimeView.layer.masksToBounds = false
        startTimeView.layer.cornerRadius = 16
        startTimeView.layer.borderColor = CGColor(red: 62/255, green: 114/255, blue: 255/255, alpha: 1)
        startTimeView.layer.borderWidth = 1
    }
    
    private func prepareEndTimeView() {
        endTimeView.layer.masksToBounds = false
        endTimeView.layer.cornerRadius = 16
        endTimeView.layer.borderColor = CGColor(red: 255/255, green: 107/255, blue: 22/255, alpha: 1)
        endTimeView.layer.borderWidth = 1
    }
    
    @objc func startImageButtonTapped() {
        guard let jwtToken = keyChainManager.jwtToken else { return }
        
        let startTime = Date()
        
        guard let dayNumber = dayNumber, let endTime = Calendar.current.date(byAdding: .day, value: dayNumber, to: startTime) else { return }
        
        ZipkokApi.shared.registerChallengeTime(jwt: jwtToken, start: startTime.challengeTimeFormat, end: endTime.challengeTimeFormat) { [weak self] registerChallengeTimeResponse in
            guard let self = self else { return }
            
            if registerChallengeTimeResponse.isSuccess {
                self.keyChainManager.challengeIdx = registerChallengeTimeResponse.result?.challengeIdx
                
                guard let timerVc = TimerViewController.storyboardInstance(), let result = registerChallengeTimeResponse.result else { return }
                
                timerVc.dayNumber = dayNumber
                timerVc.challengeIdx = result.challengeIdx
                timerVc.startDate = startTime
                timerVc.endDate = endTime
                
                self.navigationController?.pushViewController(timerVc, animated: true)
            } else {
                print("---> Challenge Register Error")
            }
        }
    }
    
    @objc func settingBarButtonItemTapped() {
        guard let settingVc = SettingViewController.storyboardInstance() else {
            fatalError()
        }
        
        navigationController?.pushViewController(settingVc, animated: true)
    }
    
    @objc func startWithFriendButtonViewTapped() {
        guard let name = keyChainManager.userName else { return }
        KakaoApi.shared.sendStartWithFriendTemplate(name: name)
    }
}
