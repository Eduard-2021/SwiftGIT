//
//  FlyweightForCGPoint.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 15.08.2021.
//

import UIKit

//Использование паттерна Flyweight в CGPoint для создания статического свойства с координатами (1,0)
extension CGPoint {
    static let oneXzeroY = CGPoint(x: 1, y: 0)
}
