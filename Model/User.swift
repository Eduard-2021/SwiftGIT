//
//  Models.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit
import Foundation

struct Likes {
    let serialNumberPhoto : Int
    let idPhoto: Int
    var image : UIImage
    var numLikes : Int
    var i_like : Bool
}

struct User {
    var id : Int
    var userAvatarURL: UIImage
    var fullName : String
    var images: [Likes]
    var numberOfImages: Int = -1
}


var friends : [User] = []
var numberOfFriends = 0



