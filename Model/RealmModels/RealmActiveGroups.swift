//
//  RealmActiveGroups.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 15.06.2021.
//

import RealmSwift

class RealmActiveGroups: Object {
    @objc dynamic var idGroup: Int = 0
    @objc dynamic var nameGroup: String = ""
    @objc dynamic var imageGroupURL: String = ""
   
    override class func primaryKey() -> String? {
        "idGroup"
    }
}

extension RealmActiveGroups {
    convenience init(_ groupsVK: VKGroup) {
        self.init()
        self.idGroup = groupsVK.idGroup
        self.nameGroup = groupsVK.nameGroup
        self.imageGroupURL = groupsVK.imageGroupURL
    }
}

class RealmActiveGroupsOrigin: Object {
    @objc dynamic var idGroup: Int = 0
    @objc dynamic var nameGroup: String = ""
    @objc dynamic var imageGroupURL: String = ""
   
    override class func primaryKey() -> String? {
        "idGroup"
    }
}

extension RealmActiveGroupsOrigin {
    convenience init(_ groupsVK: VKGroup) {
        self.init()
        self.idGroup = groupsVK.idGroup
        self.nameGroup = groupsVK.nameGroup
        self.imageGroupURL = groupsVK.imageGroupURL
    }
}
