//
//  TimerViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/12.
//

import UIKit
import MBCircularProgressBar
import Toast_Swift

class TimerViewController: UIViewController {

    @IBOutlet private weak var circleProgressBar: MBCircularProgressBarView!
    @IBOutlet private weak var percentView: UIView!
    @IBOutlet private weak var startTimeView: UIView!
    @IBOutlet private weak var endTimeView: UIView!
    @IBOutlet private weak var quitButtonView: UIView!
    
    @IBOutlet private weak var percentLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    
    private let keyChainManager = KeyChainManager()
    private let dateManager = DateManager()
    
    private lazy var quitAlertView: ChallengeQuitAlertView = {
        let quitAlertView = ChallengeQuitAlertView.loadViewFromNib()
        quitAlertView.translatesAutoresizingMaskIntoConstraints = false
        
        let quitTapGesture = UITapGestureRecognizer(target: self, action: #selector(quitAlertDissmissButtonTapped))
        quitAlertView.cancelButtonView.addGestureRecognizer(quitTapGesture)
        quitAlertView.cancelButtonView.isUserInteractionEnabled = true
        
        let failTapGesture = UITapGestureRecognizer(target: self, action: #selector(quitAlertFailButtonTapped))
        quitAlertView.quitButtonView.addGestureRecognizer(failTapGesture)
        quitAlertView.quitButtonView.isUserInteractionEnabled = true
        return quitAlertView
    }()
    
    private lazy var successAlertView: ChallengeSuccessAlertView = {
        let successAlertView = ChallengeSuccessAlertView.loadViewFromNib()
        successAlertView.translatesAutoresizingMaskIntoConstraints = false
        
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(successAlertDismissButtonTapped))
        successAlertView.dismissButton.addGestureRecognizer(dismissTapGesture)
        successAlertView.dismissButton.isUserInteractionEnabled = true
        
        let shareTapGesture = UITapGestureRecognizer(target: self, action: #selector(shareChallegeSuccedButtonTapped))
        successAlertView.shareButtonView.addGestureRecognizer(shareTapGesture)
        successAlertView.shareButtonView.isUserInteractionEnabled = true
        
        return successAlertView
    }()
    
    private var timer: Timer?
    
    private var currentTime: Int = 0
    private var timeInterval: Int = 0
    
    private var timePecent: String {
        let percent = (Double(self.currentTime) / Double(self.timeInterval)) * 100
        return String(format: "%2.0f", percent) + "%"
    }
    
    // timer restore properties
    private var remainTimeInterval: Double = 0
    private var isProgressAnimated: Bool = false
    
    // timer restore flag
    var isActiveFromBackground: Bool = false
    
    // Dependency injection from other vc
    var dayNumber: Int?
    var challengeIdx: Int?
    var startDate: Date?
    var endDate: Date?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startDate = startDate, let endDate = endDate {
            timeInterval = Int(endDate.timeIntervalSince(startDate))
            startDateLabel.text = startDate.challengeSelectTimeFormat
            endDateLabel.text = endDate.challengeSelectTimeFormat
        }
        setNavigationComponents()
        prepareCircleProgressBar()
        prepareProgressBar()
        prepareStartTimeView()
        prepareEndTimeView()
        prepareQuitButtonView()
        prepareNavigationBarItems()
        prepareTimeLabel() // timer font
        prepareNotification()
        prepareTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isActiveFromBackground {
            restoreTimer() // Access from background or sceneDelegate
        } else {
            animateCircleProgressBar(with: Double(timeInterval))
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isActiveFromBackground = true
        isProgressAnimated = false
        
        timer?.invalidate()
        timer = nil
        
        circleProgressBar.value = 0
        circleProgressBar.layer.removeAllAnimations()
    }
    
    static func storyboardInstance() -> TimerViewController? {
        let storyboard = UIStoryboard(name: TimerViewController.storyboardName(), bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    private func setNavigationComponents() {
        navigationItem.hidesBackButton = true
    }
    
    private func prepareTimeLabel() {
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 36, weight: .regular)
    }
    
    private func prepareCircleProgressBar() {
        percentView.layer.masksToBounds = false
        percentView.layer.cornerRadius = 16
    }
    
    private func prepareProgressBar() {
        circleProgressBar.valueFontSize = 0
        circleProgressBar.unitFontSize = 0
        circleProgressBar.progressAngle = 60
        
        circleProgressBar.progressLineWidth = 10
        circleProgressBar.progressColor = UIColor(red: 34/255, green: 145/255, blue: 255/255, alpha: 1)
        circleProgressBar.progressStrokeColor = UIColor(red: 34/255, green: 145/255, blue: 255/255, alpha: 1)
        
        circleProgressBar.emptyLineColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        circleProgressBar.emptyLineStrokeColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        circleProgressBar.emptyCapType = 1
        circleProgressBar.emptyLineWidth = 10
    }
    
    private func prepareNavigationBarItems() {
        let profileBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 114")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        profileBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 116")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(shareBarButtonItemTapped))
        shareBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        let settingBarButtonItem = UIBarButtonItem(image: UIImage(named: "그룹 113")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(settingBarButtonItemTapped))
        settingBarButtonItem.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        
        navigationItem.leftBarButtonItem = profileBarButtonItem
        navigationItem.rightBarButtonItems = [settingBarButtonItem, shareBarButtonItem]
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
    
    private func prepareQuitButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(quitButtonViewTapped))
        quitButtonView.addGestureRecognizer(tapGesture)
        quitButtonView.isUserInteractionEnabled = true
        quitButtonView.layer.masksToBounds = false
        quitButtonView.layer.cornerRadius = 8
    }
    
    private func prepareNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(sceneDidBecomeActive), name: UIScene.didActivateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    private func prepareTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
    
                self.timeLabel.text = self.currentTime.digitalFormat
                self.percentLabel.text = self.timePecent
                self.currentTime += 1
                
                if self.currentTime > self.timeInterval {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.successChallenge()
                }
                
                if !self.isProgressAnimated, self.remainTimeInterval != 0.0 {
                    self.isProgressAnimated = true
                    self.animateCircleProgressBar(with: self.remainTimeInterval)
                }
            })
        }
    }
    
    private func animateCircleProgressBar(with time: TimeInterval) {
        isProgressAnimated = true
        UIView.animate(withDuration: time * 1.1, animations: {
            self.circleProgressBar.value = 100
        })
    }
    
    private func alertChallengeSuccessAlertView() {
        guard let navVc = navigationController else { return }

        successAlertView.setUserName(by: keyChainManager.userName)
        navVc.view.addSubview(successAlertView)
        
        NSLayoutConstraint.activate([
            successAlertView.topAnchor.constraint(equalTo: view.topAnchor),
            successAlertView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            successAlertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            successAlertView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func successChallenge() {
        guard let jwtToken = keyChainManager.jwtToken, let idx = keyChainManager.challengeIdx else {
            print("---> jwtToken, idx can't loaded")
            return
        }
                
        ZipkokApi.shared.successChallenge(jwt: jwtToken, idx: idx) { successChallengeResponse in
            if successChallengeResponse.isSuccess {
                self.alertChallengeSuccessAlertView()
            } else {
                print("---> challenge success error")
            }
        }
    }
    
    private func restoreTimer() {
        guard isActiveFromBackground == true, let startDate = startDate, let endDate = endDate else { return }
        
        let totalTimeInterval = endDate.timeIntervalSince(startDate)
        let currentData = Date()
        
        if currentData >= endDate {
            timeLabel.text = Int(totalTimeInterval).digitalFormat
            percentLabel.text = "100%"
            circleProgressBar.value = 100
            successChallenge()
        } else {
            let passedTimeInterval = currentData.timeIntervalSince(startDate)
            self.remainTimeInterval = totalTimeInterval - passedTimeInterval
            let percent = (passedTimeInterval / totalTimeInterval) * 100
            
            currentTime = Int(passedTimeInterval)

            circleProgressBar.value = CGFloat(percent)
            circleProgressBar.layer.removeAllAnimations()
            
            prepareTimer()
        }
    }
    
    @objc func sceneDidBecomeActive() {
        restoreTimer()
    }
    
    @objc func didEnterBackgroundNotification() {
        isActiveFromBackground = true
        isProgressAnimated = false
        
        timer?.invalidate()
        timer = nil
        
        circleProgressBar.value = 0
        circleProgressBar.layer.removeAllAnimations()
    }
    
    @objc func quitButtonViewTapped() {
        guard let navVc = navigationController else { return }

        quitAlertView.setUserName(by: keyChainManager.userName)
        navVc.view.addSubview(quitAlertView)
        
        NSLayoutConstraint.activate([
            quitAlertView.topAnchor.constraint(equalTo: view.topAnchor),
            quitAlertView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            quitAlertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            quitAlertView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func quitAlertDissmissButtonTapped() {
        quitAlertView.removeFromSuperview()
    }
    
    @objc func quitAlertFailButtonTapped() {
        guard let jwtToken = keyChainManager.jwtToken, let idx = challengeIdx else { return }
        
        ZipkokApi.shared.failChallenge(jwt: jwtToken, idx: idx) { failChallengeResponse in
            if failChallengeResponse.isSuccess {
                self.quitAlertView.removeFromSuperview()
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                // 예외처리
            }
        }
    }
    
    @objc func successAlertDismissButtonTapped() {
        successAlertView.removeFromSuperview()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func settingBarButtonItemTapped() {
        guard let settingVc = SettingViewController.storyboardInstance() else {
            fatalError()
        }
        
        navigationController?.pushViewController(settingVc, animated: true)
    }
    
    @objc func shareBarButtonItemTapped() {
        guard let name = keyChainManager.userName else { return }
        
        var secondInterval = currentTime
        
        let hour = secondInterval / 3600
        secondInterval %= 3600
        
        let min = secondInterval / 60
        
        KakaoApi.shared.sendChallengeTime(name: name, hour: hour, minute: min)
    }
    
    @objc func shareChallegeSuccedButtonTapped() {
        guard let name = keyChainManager.userName, let day = dayNumber else { return }
        
        KakaoApi.shared.sendChallengeSucced(name: name, day: day)
    }
}

extension Int {
    var digitalFormat: String {
        var timeInterval = self
        let hour = timeInterval / 3600
        timeInterval %= 3600
        
        let minute = timeInterval / 60
        timeInterval %= 60
        
        let sec = timeInterval
        return String(format: "%02d:%02d:%02d", hour, minute, sec)
    }
}
