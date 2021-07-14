//
//  Groups.swift
//  VK_PlusHW2.3
//
//  Created by Eduard on 02.06.2021.
//

struct VKGroup {
    let idGroup : Int
    let nameGroup: String
    let imageGroupURL : String
}

extension VKGroup: Codable {
    enum CodingKeys: String, CodingKey {
        case idGroup = "id"
        case nameGroup = "name"
        case imageGroupURL = "photo_200"
    }
}
