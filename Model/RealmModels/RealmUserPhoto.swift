//
//  RealmUserPhotos.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 09.06.2021.
//

import RealmSwift

class RealmUserPhoto: Object {
    @objc dynamic var idUser: Int = 0
    @objc dynamic var serialNumberPhoto: Int = 0
    @objc dynamic var idPhoto: Int = 0
    @objc dynamic var URLimage: String = ""
    @objc dynamic var numLikes: Int = 0
    @objc dynamic var i_like: Bool = false

    override class func primaryKey() -> String? {
        "idPhoto"
    }
    
//    override class func indexedProperties() -> [String] {
//        ["firstName", "lastName"]
//    }
}

extension RealmUserPhoto {
    convenience init(_ idUser: Int, _ onePhoto: OnePhoto, _ URLimage: String, _ likesVK: LikesVK) {
        self.init()
        self.idUser = idUser
        self.serialNumberPhoto = 0
        self.idPhoto = onePhoto.idPhoto
        self.URLimage = URLimage
        self.numLikes = likesVK.count
        self.i_like = likesVK.userLikes == 1
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

