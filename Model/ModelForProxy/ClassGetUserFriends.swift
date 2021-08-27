//
//  ClassGetUserFriends.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 27.08.2021.
//

import Foundation

class ClassGetUserFriends: ProtocolForLogger {
    var nameRequest: String
    var date: NSDate
    
    init(nameRequest: String, date: NSDate){
        self.nameRequest = nameRequest
        self.date = date
    }
}
