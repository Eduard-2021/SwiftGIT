//
//  Group.swift
//  VK_PlusHW3
//
//  Created by Eduard on 07.04.2021.
//

import UIKit
import Foundation

struct Group :Equatable {
    let imageGroup: UIImage
    let nameGroup : String
}

var activeGroups : [Group] = []
var allGroups : [Group] = []
var numberOfGroups = -1
var numberOfFoundGroups = -1
