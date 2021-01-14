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
    
    let dateManager = DateManager()
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCircleProgressBar()
        prepareProgressBar()
        prepareStartTimeView()
        prepareEndTimeView()
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
}
