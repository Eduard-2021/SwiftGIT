//
//  ClassGetGroupsOfUser.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 27.08.2021.
//

import Foundation

class ClassGetGroupsOfUser: ProtocolForLogger {
    var nameRequest: String
    var date: NSDate
    var userId:Int
    
    init(nameRequest: String, date: NSDate, userId:Int){
        self.nameRequest = nameRequest
        self.date = date
        self.userId = userId
    }
    
    
}
