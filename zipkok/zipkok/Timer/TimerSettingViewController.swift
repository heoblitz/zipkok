//
//  TimerSettingViewController.swift
//  zipkok
//
//  Created by won heo on 2021/01/11.
//

import UIKit

class TimerSettingViewController: UIViewController {

    @IBOutlet private weak var startButtonView: UIView!
    @IBOutlet private weak var startTimeView: UIView!
    @IBOutlet private weak var endTimeView: UIView!
    @IBOutlet private var dotLineViews: [UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStartButtonView()
        prepareStartTimeView()
        prepareEndTimeView()
        prepareDotLineViews()
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
    
    private func prepareDotLineViews() {
        dotLineViews?.forEach {
            drawDottedLine(for: $0)
        }
    }
    
    private func drawDottedLine(for view: UIView) {
        let start = CGPoint(x: view.bounds.minX, y: view.bounds.minY)
        let end = CGPoint(x: view.bounds.maxX, y: view.bounds.minY)
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = CGColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
}
