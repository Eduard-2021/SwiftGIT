//
//  OneVKGroup.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 15.07.2021.
//

struct OneVKGroup {
    var id: Int
    var name: String
    var photoURL: String
}

extension OneVKGroup: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photoURL = "photo_200"
    }
}

