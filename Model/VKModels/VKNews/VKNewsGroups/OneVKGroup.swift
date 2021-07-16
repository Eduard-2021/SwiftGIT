//
//  OneVKGroup.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 15.07.2021.
//

struct OneVKGroup {
    let id: Int
    let name: String
    let photoURL: String
}

extension OneVKGroup: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photoURL = "photo_50"
    }
}

