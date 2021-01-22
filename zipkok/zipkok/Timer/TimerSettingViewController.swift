//
//  TimerSettingViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

class TimerSettingViewController: UIViewController {

    @IBOutlet private weak var startButtonView: UIView!
    @IBOutlet private weak var startImageView: UIImageView!
    @IBOutlet private weak var startTimeView: UIView!
    @IBOutlet private weak var endTimeView: UIView!
    
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    
    private let keyChainManager = KeyChainManager()

    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startDate = startDate, let endDate = endDate {
            startDateLabel.text = startDate.challengeSelectTimeFormat
            endDateLabel.text = endDate.challengeSelectTimeFormat
        }
        
        prepareStartImageView()
        prepareStartButtonView()
        prepareStartTimeView()
        prepareEndTimeView()
    }
    
    private func prepareStartImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startImageButtonTapped))
        startImageView.isUserInteractionEnabled = true
        startImageView.addGestureRecognizer(tapGesture)
    }
    
    private func prepareStartButtonView() {
        startButtonView.layer.masksToBounds = false
        startButtonView.layer.cornerRadius = 8
        startButtonView.layer.borderColor = CGColor(red: 62/255, green: 115/255, blue: 255/255, alpha: 1)
        startButtonView.layer.borderWidth = 1
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
        guard let jwtToken = keyChainManager.jwtToken, let startTime = startDate, let endTime = endDate else { return }
        guard let timerVc = UIStoryboard(name: "Timer", bundle: nil).instantiateInitialViewController() as? TimerViewController else { return }
        
        ZipkokApi.shared.registerChallengeTime(jwt: jwtToken, start: startTime.challengeTimeFormat, end: endTime.challengeTimeFormat) { [weak self] registerChallengeTimeResponse in
            guard let self = self else { return }
            
            if registerChallengeTimeResponse.isSuccess {
                timerVc.startDate = startTime
                timerVc.endDate = endTime
                self.navigationController?.pushViewController(timerVc, animated: true)
            } else {
                print("타임 등록이 되었는가")
            }
        }
        
        navigationController?.pushViewController(timerVc, animated: true)
    }
}
