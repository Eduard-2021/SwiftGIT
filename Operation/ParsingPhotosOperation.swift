//
//  ParsingPhotoOperation.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 16.07.2021.
//

import Foundation

class ParsingPhotosOperation: AsyncOperation {
    
    var allPhotos: VKResponse<AllPhotoOfFriend>?
    var userId = ""

    override func main() {
        guard let getPhotosOperation = dependencies.first as? GetPhotosOperation,
              let data = getPhotosOperation.data else { return }
        
        userId = getPhotosOperation.userId
        allPhotos = try? JSONDecoder().decode(VKResponse<AllPhotoOfFriend>.self, from: data)
        self.state = .finished
    }
}
