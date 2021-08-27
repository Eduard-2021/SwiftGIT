//
//  ClassGetUsersOfNews.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 27.08.2021.
//

import Foundation

class ClassGetUsersOfNews: ProtocolForLogger {
    var nameRequest: String
    var date: NSDate
    var usersIDs: String
    
    init(nameRequest: String, date: NSDate, usersIDs: String){
        self.nameRequest = nameRequest
        self.date = date
        self.usersIDs = usersIDs
    }
}
