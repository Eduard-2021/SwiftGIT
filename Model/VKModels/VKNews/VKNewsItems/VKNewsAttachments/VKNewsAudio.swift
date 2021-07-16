//
//  VKNewsAudio.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 08.07.2021.
//

struct  VKNewsAudio {
    var artist: String = ""
    var id: Int = 0
    var title: String = ""
    var trackCode: String = ""

}

extension VKNewsAudio: Decodable {
    enum CodingKeys: String, CodingKey {
        case trackCode = "track_code"
    }
}
