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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let timerVc = UIStoryboard(name: "Timer", bundle: nil).instantiateInitialViewController() as? TimerViewController else { fatalError() }
        timerVc.startDate = Date()
        timerVc.endDate = Date(timeIntervalSinceNow: 30)
        
        navigationController?.pushViewController(timerVc, animated: true)
    }
}
