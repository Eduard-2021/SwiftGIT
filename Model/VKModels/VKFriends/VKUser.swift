//
//  VKUser.swift
//  VK_PlusHW2.2
//
//  Created by Eduard on 30.05.2021.
//

import Foundation

struct VKUser {
    let id: Int
    let firstName: String
    let lastName: String
    let userAvatarURL: String
}

extension VKUser: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case userAvatarURL = "photo_200"
    }
}
