//
//  MainNetworkService.swift
//  VK_PlusHW2.2
//
//  Created by Eduard on 25.05.2021.
//

import Foundation
import UIKit
import RealmSwift


final class MainNetworkService {
    static let photoTest = UIImageView()
    
    private let apiVersion = "5.130"
    
    private func makeComponents(for path: PathOfMethodsVK) -> URLComponents {
        let urlComponent: URLComponents = {
            var url = URLComponents()
            url.scheme = "https"
            url.host = "api.vk.com"
            url.path = "/method/\(path.rawValue)"
            url.queryItems = [
                URLQueryItem(name: "access_token", value: DataAboutSession.data.token),
                URLQueryItem(name: "v", value: apiVersion),
            ]
            return url
        }()
        return urlComponent
    }
    
    
    func getUserFriends(completion: @escaping ([RealmUser]?, [RealmUserOrigin]?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getFriends)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "fields", value: "photo_200"),
        ])
        
        guard let url = urlComponents.url else {return}
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let vkResponse = try? JSONDecoder().decode(VKResponse<VKFriends>.self, from: data)
                guard let vkResponses = vkResponse else {completion(nil, nil); return}

                let allFriendsInRealm = vkResponses.response.items.map {RealmUser($0)}
                let allFriendsInRealmUnsorted = vkResponses.response.items.map {RealmUserOrigin($0)}
                DispatchQueue.main.async {
                    completion(allFriendsInRealm, allFriendsInRealmUnsorted)
                }
            }
        }
        .resume()
    }
        
    func getAllPhotos(userId:String, completion: @escaping ([RealmUserPhoto]?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getAllPhotos)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "owner_id", value: "\(userId)")
        ])
        guard let url = urlComponents.url else
        { return }
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let vkResponse = try? JSONDecoder().decode(VKResponse<AllPhotoOfFriend>.self, from: data)
                guard let vkResponses = vkResponse else {completion(nil); return}
                
                let allPhotosOfFriendsInRealm = vkResponses.response.items.map {RealmUserPhoto(Int(userId)!,$0,$0.differentSize.first(where: { (400..<650).contains($0.width) })?.url ?? "", LikesVK($0.allLikes))}
                DispatchQueue.main.async {
                    completion(allPhotosOfFriendsInRealm)
                }
            }
        }
        .resume()
    }
        
    
    
    func getGroupsOfUser(userId:Int, completion: @escaping ([RealmActiveGroups]?, [RealmActiveGroupsOrigin]?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .getGroupsUser)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "user_id", value: "\(userId)")
        ])
        
        guard let url = urlComponents.url else {return}
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let vkResponse = try? JSONDecoder().decode(VKResponse<ActiveAndFoundGroups>.self, from: data)
                guard let vkResponses = vkResponse else {completion(nil, nil); return}
                
                let activeGroupsInRealm = vkResponses.response.items.map {RealmActiveGroups($0)}
                let activeGroupsInRealmOrigin = vkResponses.response.items.map {RealmActiveGroupsOrigin($0)}
                DispatchQueue.main.async {
                    completion(activeGroupsInRealm, activeGroupsInRealmOrigin)
                }
            }
        }
        .resume()
    }
    
    
    func groupsSearch (textForSearch : String, numberGroups: Int, completion: @escaping ([RealmAllGroups]?) -> Void) {
        let session = URLSession.shared
        var urlComponents = makeComponents(for: .groupsSearch)
        urlComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "q", value: textForSearch),
            URLQueryItem(name: "count", value: "\(numberGroups)")
        ])
        
        guard let url = urlComponents.url else {return}
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let vkResponse = try? JSONDecoder().decode(VKResponse<ActiveAndFoundGroups>.self, from: data)
                guard let vkResponses = vkResponse else {completion(nil); return}
                
                let allSearchedGroupsinRealm = vkResponses.response.items.map {RealmAllGroups($0)}
                DispatchQueue.main.async {
                    completion(allSearchedGroupsinRealm)
                }
            }
        }
        .resume()
    }
}


