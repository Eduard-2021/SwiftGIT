//
//  MainNetworkServiceProxy.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 26.08.2021.
//

import UIKit

final class MainNetworkServiceProxy {
    let mainNetworkService: MainNetworkService
    
    init (mainNetworkService: MainNetworkService){
        self.mainNetworkService = mainNetworkService
    }
    
    //Метод сохранения(логирования) всех запросов в синглтон-массиве. Массив очищаеться после внесения в него 100 записей
    private func saveInLogger(classForSave: ProtocolForLogger) {
        if SingltonForLogger.shared.logger.count < 100 {
            SingltonForLogger.shared.logger.append(classForSave)
        }
        else  {
            SingltonForLogger.shared.logger = []
        }
    }
    
    func getUserFriends(completion: @escaping ([RealmUser]?, [RealmUserOrigin]?) -> Void) {
        saveInLogger(classForSave: ClassGetUserFriends(nameRequest: "GetUserFriends", date: NSDate() ))
        mainNetworkService.getUserFriends(completion: completion)
    }
        
    func getAllPhotos(userId:String, completion: @escaping ([RealmUserPhoto]?) -> Void) {
        saveInLogger(classForSave: ClassGetAllPhotos(nameRequest: "GetAllPhotos", date: NSDate(), userId: userId))
        mainNetworkService.getAllPhotos(userId: userId, completion:completion)
    }
        
   
    func getGroupsOfUser(userId:Int, completion: @escaping ([RealmActiveGroups]?, [RealmActiveGroupsOrigin]?) -> Void) {
        saveInLogger(classForSave: ClassGetGroupsOfUser(nameRequest: "GetGroupsOfUser", date: NSDate(), userId: userId))
        mainNetworkService.getGroupsOfUser(userId: userId, completion:completion)
    }
    
    
    func groupsSearch (textForSearch : String, numberGroups: Int, completion: @escaping ([RealmAllGroups]?) -> Void) {
        saveInLogger(classForSave: ClassGroupsSearch(nameRequest: "GroupsSearch", date: NSDate(), textForSearch: textForSearch))
        mainNetworkService.groupsSearch(textForSearch: textForSearch, numberGroups: numberGroups, completion: completion)
    }
    
    func getNews(startTime: Double, endTime: Double = Date().timeIntervalSince1970, nextGroup: String = "", completion: @escaping (VKResponseDecodable<VKNewsItems>?,VKResponse<VKNewsProfiles>?,VKResponse<VKNewsGroups>?, VKResponse<VKNextGroupOfNews>?) -> Void) {
        saveInLogger(classForSave: ClassGetNews(nameRequest: "GetNews", date: NSDate(), startTime: startTime, endTime: endTime, nextGroup: nextGroup))
        
        mainNetworkService.getNews(startTime: startTime, endTime: endTime, nextGroup: nextGroup, completion: completion)
    }

    func getGroupsOfNews(groupsIDs: String, completion: @escaping (VKResponseArray<VKGroup>?) -> Void) {
        saveInLogger(classForSave: ClassGetGroupsOfNews(nameRequest: "GetGroupsOfNews", date: NSDate(), groupsIDs:groupsIDs))
        mainNetworkService.getGroupsOfNews(groupsIDs: groupsIDs, completion: completion)
    }
    
    func getUsersOfNews(usersIDs: String, completion: @escaping (VKResponseArray<VKUser>?) -> Void) {
        saveInLogger(classForSave: ClassGetUsersOfNews(nameRequest: "GetUsersOfNews", date: NSDate(), usersIDs:usersIDs))
        mainNetworkService.getUsersOfNews(usersIDs: usersIDs, completion: completion)
    }
}
