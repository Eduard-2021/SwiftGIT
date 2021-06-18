//
//  RealmUser.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 09.06.2021.
//

import RealmSwift

class RealmUser: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var userAvatarURL: String = ""
    @objc dynamic var fullName: String = ""
    var images = List<RealmUserPhoto>()
    @objc dynamic var sectionNumber: Int = 0
    @objc dynamic var numberOfSection: Int = 0

    
    override class func primaryKey() -> String? {
        "id"
    }
    
    override class func indexedProperties() -> [String] {
        ["firstName", "lastName"]
    }
}

extension RealmUser {
    convenience init(_ userVK: VKUser) {
        self.init()
        self.id = userVK.idUser
        self.firstName = userVK.firstName
        self.lastName = userVK.lastName
        self.userAvatarURL = userVK.userAvatarURL
        self.fullName = "\(self.lastName) \(self.firstName)"
    }
}


class RealmUserOrigin: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var userAvatarURL: String = ""
    @objc dynamic var fullName: String = ""
    var images = List<RealmUserPhoto>()
    @objc dynamic var sectionNumber: Int = 0
    @objc dynamic var numberOfSection: Int = 0

    
    override class func primaryKey() -> String? {
        "id"
    }
    
    override class func indexedProperties() -> [String] {
        ["firstName", "lastName"]
    }
}

extension RealmUserOrigin {
    convenience init(_ userVK: VKUser) {
        self.init()
        self.id = userVK.idUser
        self.firstName = userVK.firstName
        self.lastName = userVK.lastName
        self.userAvatarURL = userVK.userAvatarURL
        self.fullName = "\(self.lastName) \(self.firstName)"
    }
}
