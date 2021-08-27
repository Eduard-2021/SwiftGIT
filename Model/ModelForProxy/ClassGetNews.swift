//
//  ClassGetNews.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 27.08.2021.
//

import Foundation

class ClassGetNews: ProtocolForLogger {
    var nameRequest: String
    var date: NSDate
    
    var startTime: Double
    var endTime: Double = Date().timeIntervalSince1970
    var nextGroup: String = ""
    
    
    init(nameRequest: String, date: NSDate, startTime: Double, endTime: Double, nextGroup: String){
        self.nameRequest = nameRequest
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.nextGroup = nextGroup
    }
}
