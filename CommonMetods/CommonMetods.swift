//
//  File.swift
//  VK_PlusHW7
//
//  Created by Eduard on 20.04.2021.
//

import Foundation
import UIKit

public func makeGradient(_ cell : Any) {
    let workCell = cell as! UIView
    let gradientLayer = CAGradientLayer()
    let startColor : UIColor = .systemBlue
    let endColor : UIColor = .white
    let startLocation : CGFloat = 0
    let endLocation : CGFloat = 1
    let startPoint : CGPoint = CGPoint(x: -0.5, y: 0)
    let endPoint : CGPoint = CGPoint(x: 1, y: 0)
    
    gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    workCell.layer.insertSublayer(gradientLayer, at: 0)
    gradientLayer.frame = workCell.bounds
}

