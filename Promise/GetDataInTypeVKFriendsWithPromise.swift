//
//  GetDataInTypeVKFriendsWithPromise.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 18.07.2021.
//

import UIKit
import PromiseKit

func getDataInTypeVKFriendsWithPromise(data: Data) -> Promise<VKResponse<VKFriends>> {
    return Promise<VKResponse<VKFriends>> { seal in
        let vkResponse = try? JSONDecoder().decode(VKResponse<VKFriends>.self, from: data)
        guard let vkResponses = vkResponse else {return seal.reject(PromiseError.notCorrectJSON)}
            seal.fulfill(vkResponses)
    }
           
}
