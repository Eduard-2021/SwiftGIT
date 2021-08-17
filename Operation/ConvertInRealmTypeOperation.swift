//
//  ConvertInRealmTypeOperation.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 16.07.2021.
//

import Foundation

class ConvertInRealmTypeOperation: AsyncOperation {
    var allPhotosOfFriendsInRealm: [RealmUserPhoto]?

    override func main() {
        guard
            let parsingPhotosOperation = dependencies.first as? ParsingPhotosOperation,
            let allPhotos = parsingPhotosOperation.allPhotos
               else { return }
        
         allPhotosOfFriendsInRealm = allPhotos.response.items.map {RealmUserPhoto(Int(parsingPhotosOperation.userId)!,$0,$0.differentSize.first(where: { (400..<650).contains($0.width) })?.url ?? "", LikesVK($0.allLikes))}
    
        self.state = .finished
    }
}
