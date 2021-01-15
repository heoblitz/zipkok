//
//  TimerViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/12.
//

import UIKit
import MBCircularProgressBar

class TimerViewController: UIViewController {

    @IBOutlet private weak var circleProgressBar: MBCircularProgressBarView!
    @IBOutlet private weak var percentView: UIView!
    @IBOutlet private weak var startTimeView: UIView!
    @IBOutlet private weak var endTimeView: UIView!
    @IBOutlet private weak var quitButtonView: UIView!
    
    @IBOutlet private weak var percentLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    private let dateManager = DateManager()
    private var isActiveFromBackground: Bool = false
    private var timer: Timer?
    
    private var currentTime: Int = 0
    private var timeInterval: Int = 0
    
    private var timePecent: String {
        let percent = (Double(self.currentTime) / Double(self.timeInterval)) * 100
        return String(format: "%2.0f", percent) + "%"
    }
    
    var startDate: Date?
    var endDate: Date?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startDate = startDate, let endDate = endDate {
            self.timeInterval = Int(endDate.timeIntervalSince(startDate))
        }
        
        prepareCircleProgressBar()
        prepareProgressBar()
        prepareStartTimeView()
        prepareEndTimeView()
        prepareQuitButtonView()
        prepareNotification()
        prepareTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCircleProgressBar(with: Double(timeInterval))
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
                    self.alertChallengeSuccessAlertView()
                }
            })
        }
    }
    
    private func animateCircleProgressBar(with time: TimeInterval) {
        UIView.animate(withDuration: time * 1.1, animations: {
            self.circleProgressBar.value = 100
        })
    }
    
    private func alertChallengeSuccessAlertView() {
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
        
    @objc func sceneDidBecomeActive() {
        guard isActiveFromBackground == true, let startDate = dateManager.startDate, let endDate = dateManager.endDate else { return }
        
        let totalTimeInterval = endDate.timeIntervalSince(startDate)
        let currentData = Date()
        
        if currentData >= endDate {
            timeLabel.text = Int(totalTimeInterval).digitalFormat
            percentLabel.text = "100%"
            circleProgressBar.value = 100
            alertChallengeSuccessAlertView()
        } else {
            let passedTimeInterval = currentData.timeIntervalSince(startDate)
            let remainTimeInterval = totalTimeInterval - passedTimeInterval
            let percent = (passedTimeInterval / totalTimeInterval) * 100
            
            currentTime = Int(passedTimeInterval)
            prepareTimer()

            circleProgressBar.value = CGFloat(percent)
            circleProgressBar.layer.removeAllAnimations()
            animateCircleProgressBar(with: remainTimeInterval)
        }
    }
    
    @objc func didEnterBackgroundNotification() {
        dateManager.startDate = self.startDate
        dateManager.endDate = self.endDate
        isActiveFromBackground = true
        
        timer?.invalidate()
        timer = nil
        
        circleProgressBar.value = 0
        circleProgressBar.layer.removeAllAnimations()
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
