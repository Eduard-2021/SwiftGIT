//
//  Groups.swift
//  VK_PlusHW2.3
//
//  Created by Eduard on 02.06.2021.
//

struct VKActiveGroup {
    let idGroup : Int
    let nameGroup: String
    let imageGroup : String
}

extension VKActiveGroup: Codable {
    enum CodingKeys: String, CodingKey {
        case idGroup = "id"
        case nameGroup = "name"
        case imageGroup = "photo_200"
    }
}
