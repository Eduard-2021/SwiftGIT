//
//  ClassGetGroupsOfNews.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 27.08.2021.
//

import Foundation

class ClassGetGroupsOfNews: ProtocolForLogger {
    var nameRequest: String
    var date: NSDate
    var groupsIDs: String
    
    init(nameRequest: String, date: NSDate, groupsIDs: String){
        self.nameRequest = nameRequest
        self.date = date
        self.groupsIDs = groupsIDs
    }
    
    
}

