//
//  ConvertAndSaveInRealmWithPromise.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 18.07.2021.
//
//
import UIKit
import PromiseKit
import RealmSwift

func convertAndSaveInRealmWithPromise(vkResponses: VKResponse<VKFriends>) -> Promise<Void> {
    
    return Promise<Void> { seal in
        var friendsInRealm = vkResponses.response.items.map{RealmUser($0)}
        var friendsOriginInRealm = vkResponses.response.items.map {RealmUserOrigin($0)}
        do {
            friendsInRealm = FriendsViewTableController().sortedFriendsFunction(friends: friendsInRealm)
        try RealmService.save(items: friendsInRealm)
            friendsOriginInRealm = FriendsViewTableController().saveOriginFriends(friendsInRealm, friendsOriginInRealm)
        try RealmService.save(items: friendsOriginInRealm)
        return seal.fulfill(())
        }
        catch {
            return seal.reject(PromiseError.cannotConvertVKTypeInReal)
        }
    }
}

