//
//  dottedLineView.swift
//  zipkok
//
//  Created by won heo on 2021/01/14.
//

import UIKit

class dottedLineView: UIView {
    override func draw(_ rect: CGRect) {
        let start = CGPoint(x: bounds.minX, y: bounds.minY)
        let end = CGPoint(x: bounds.maxX, y: bounds.minY)
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = CGColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3]

        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
