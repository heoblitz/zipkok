//
//  ChallengeTimerView.swift
//  zipkok
//
//  Created by won heo on 2021/01/13.
//

import UIKit

class ChallengeTimerView: UIView {
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지속시간"
        label.textColor = UIColor(red: 149/255, green: 149/255, blue: 149/255, alpha: 1)
        label.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "13:25:03"
        label.font = UIFont(name: "Montserrat-Regular", size: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let percentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 62/255, green: 114/255, blue: 255/255, alpha: 1)
        label.font = UIFont(name: "Montserrat-Medium", size: 18)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 62/255, green: 114/255, blue: 255/255, alpha: 0.1)
        label.clipsToBounds = true
        label.layer.cornerRadius = 16
        label.text = "56%"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        // drawTimerRemain()
        prepareLabels()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawTimerBackGround()
        drawTimerRemain()
    }
    
    func drawTimerBackGround() { // 90, 180
        let line = CAShapeLayer()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let path = UIBezierPath(arcCenter: center, radius: 120, startAngle: -200.degreesToRadians, endAngle: 20.degreesToRadians, clockwise: true).cgPath
        line.path = path
        line.lineWidth = 12
        line.lineCap = .round
        line.strokeColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        line.fillColor = UIColor.clear.cgColor
        line.frame = bounds
        layer.addSublayer(line)
    }
    
    func drawTimerRemain() {
        let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
        let line = CAShapeLayer()
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let path = UIBezierPath(arcCenter: center, radius: 120, startAngle: -200.degreesToRadians, endAngle: 20.degreesToRadians, clockwise: true).cgPath
        line.path = path
        line.lineWidth = 12
        line.lineCap = .round
        line.strokeColor = UIColor(red: 34/255, green: 145/255, blue: 255/255, alpha: 1).cgColor
        line.fillColor = UIColor.clear.cgColor
        
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.duration = 10
        
        line.add(strokeIt, forKey: nil)
        layer.addSublayer(line)
    }
    
    func prepareLabels() {
        addSubview(subTitleLabel)
        addSubview(currentTimeLabel)
        addSubview(percentLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 51),
            currentTimeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            currentTimeLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            percentLabel.widthAnchor.constraint(equalToConstant: 66),
            percentLabel.heightAnchor.constraint(equalToConstant: 30),
            percentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            percentLabel.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 45)
        ])
    }
}


extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
