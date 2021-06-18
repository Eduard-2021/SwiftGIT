//
//  RealmUserPhotos.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 09.06.2021.
//

import RealmSwift

class RealmUserPhotos: Object {
    @objc dynamic var serialNumberPhoto: Int = 0
    @objc dynamic var idPhoto: Int = 0
    var image = List<SizeVK>()
    @objc dynamic var numLikes: Int = 0
    @objc dynamic var i_like: Bool = false

    override class func primaryKey() -> String? {
        "idPhoto"
    }
    
//    override class func indexedProperties() -> [String] {
//        ["firstName", "lastName"]
//    }
}

extension RealmUserPhotos {
    convenience init(_ onePhoto: OnePhoto, _ allSizesOfImage: List<SizeVK>, _ likesVK: LikesVK) {
        self.init()
        self.serialNumberPhoto = 0
        self.idPhoto = onePhoto.idPhoto
        self.image = allSizesOfImage
        self.numLikes = likesVK.count
        self.i_like = likesVK.userLikes == 1
    }
}


class SizeVK: Object {
    @objc dynamic var height : Int = 0
    @objc dynamic var url : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var width : Int = 0
}

extension SizeVK {
    convenience init(_ oneSizePhoto: Size) {
        self.init()
        self.height = oneSizePhoto.height
        self.url = oneSizePhoto.url
        self.type = oneSizePhoto.type
        self.width = oneSizePhoto.width
    }
}

class LikesVK: Object {
    @objc dynamic var userLikes : Int = 0
    @objc dynamic var count : Int = 0
}

extension LikesVK {
    convenience init(_ likesVK: VKLikes) {
        self.init()
        self.userLikes = likesVK.userLikes
        self.count = likesVK.count
    }
}

