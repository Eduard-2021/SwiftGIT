//
//  Logger.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 26.08.2021.
//

import UIKit

class SingltonForLogger {
    static let shared = SingltonForLogger()
    private init(){}
    var logger = [ProtocolForLogger]()
}
