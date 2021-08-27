//
//  ClassGroupsSearch.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 27.08.2021.
//

import Foundation

class ClassGroupsSearch: ProtocolForLogger {
    var nameRequest: String
    var date: NSDate
    var textForSearch : String
    
    init(nameRequest: String, date: NSDate, textForSearch : String){
        self.nameRequest = nameRequest
        self.date = date
        self.textForSearch = textForSearch
    }
    
    
}
