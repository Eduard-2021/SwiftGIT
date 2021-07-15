//
//  VKNewsPhoto.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 02.07.2021.
//

struct VKNewsPhoto  {
    var id: Int = 0
    var ownerID: Int = 0
    var userID: Int = 0
    var text: String = ""
    var date: Double = 0
    var sizes = [SizeVKNewsPhoto]()
}

//extension VKNewsPhoto: Decodable {
//    enum CodingKeys: String, CodingKey {
//        case ownerID = "owner_id"
//        case userID = "user_id"
//    }
//}
