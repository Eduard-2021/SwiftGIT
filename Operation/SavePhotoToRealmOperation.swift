//
//  SavePhotoToRealm.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 16.07.2021.
//

import Foundation

class SavePhotoToRealmOperation: AsyncOperation {
    
    override func main() {
        guard let parsingPhotosOperation = dependencies.first as? ConvertInRealmTypeOperation,
              let vkPhotos = parsingPhotosOperation.allPhotosOfFriendsInRealm
            else { return }
        
        var vkPhotosWithNumber = [RealmUserPhoto]()
        for (index,value) in vkPhotos.enumerated() {
            vkPhotosWithNumber.append(value)
            vkPhotosWithNumber[index].serialNumberPhoto = index
        }
//        DispatchQueue.main.async {
            do {
                //сохранение данных в Realm
                try RealmService.save(items: vkPhotosWithNumber)
                self.state = .finished
            }
            catch {
                print(error)
            }
//        }
    }
}
