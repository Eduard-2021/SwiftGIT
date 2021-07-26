//
//  VKNextGroupOfNews.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 23.07.2021.
//

struct VKNextGroupOfNews {
    let nextGroupFrom: String
}

extension VKNextGroupOfNews: Codable {
    enum CodingKeys: String, CodingKey {
        case nextGroupFrom = "next_from"
    }
}


