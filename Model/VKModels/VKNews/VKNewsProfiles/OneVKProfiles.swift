//
//  OneVKProfiles.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 15.07.2021.
//

struct OneVKProfiles {
    let firstName: String
    let id: Int
    let lastName: String
    let photoURL: String
}

extension OneVKProfiles: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case photoURL = "photo_50"
    }
}
