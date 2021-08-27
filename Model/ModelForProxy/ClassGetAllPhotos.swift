//
//  ClassGetAllPhotos.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 27.08.2021.
//

import Foundation

class ClassGetAllPhotos: ProtocolForLogger {
    var nameRequest: String
    var date: NSDate
    var userId:String
    
    init(nameRequest: String, date: NSDate, userId:String){
        self.nameRequest = nameRequest
        self.date = date
        self.userId = userId
    }
    
}
