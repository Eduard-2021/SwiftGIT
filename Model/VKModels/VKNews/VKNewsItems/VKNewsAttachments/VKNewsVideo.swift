//
//  VKNewsVideo.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 08.07.2021.
//

struct VKNewsVideo {
    var id: Int = 0
    var ownerID : Int = 0
    var title: String = ""
    var image = CoverPhoto()
}

extension VKNewsVideo: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, image
        case ownerID = "owner_id"
    }
}

struct CoverPhoto: Decodable {
    var height: Int = 0
    var width: Int = 0
    var url: String = ""
}

