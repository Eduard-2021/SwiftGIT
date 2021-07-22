//
//  NewsTableViewController.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit


class NewsTableViewController: UITableViewController {
    
    private let networkService = MainNetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getNews { [weak self] (vkResponseItems,
                                             vkResponsePRofiles,
                                             vkResponseGroups) in
            guard let newsVKUnwrapped = vkResponseItems?.response.items else {return}
            newsVK = newsVKUnwrapped
            var groupsIDs = ""
            var usersIDs = ""
            for (_, value) in newsVK.enumerated() {
                if !groupsIDs.contains(String(abs(value.sourceID))),
                   value.sourceID < 0 {
                    groupsIDs += String(abs(value.sourceID)) + ","
                }
                else if !usersIDs.contains(String(abs(value.sourceID))),
                        value.sourceID > 0 {
                         usersIDs += String(abs(value.sourceID)) + ","
                     }
                
            }
            if !groupsIDs.isEmpty {
                groupsIDs.removeLast()
                self!.networkService.getGroupsOfNews(groupsIDs: groupsIDs, completion: { [weak self] vkResponse in
                    guard let groupsOfNews = vkResponse?.response else {return}
                    var groupsOfNewsDict = [Int:VKGroup]()
                    for value in groupsOfNews {groupsOfNewsDict[value.idGroup] = value}
                    for (index, _) in newsVK.enumerated() {
                        if let groupsOfNews = groupsOfNewsDict[abs(newsVK[index].sourceID)] {
                          newsVK[index].newsGroupVK = groupsOfNews
                            }
                    }
                    self!.tableView.reloadData()
                })
            }
            if !usersIDs.isEmpty {
                usersIDs.removeLast()
                self!.networkService.getUsersOfNews(usersIDs: usersIDs, completion: { [weak self] vkResponse in
                    guard let usersOfNews = vkResponse?.response else {return}
                    var usersOfNewsDict = [Int:VKUser]()
                    for value in usersOfNews {usersOfNewsDict[value.idUser] = value}
                    for (index, _) in newsVK.enumerated() {
                        if let userOfNews = usersOfNewsDict[abs(newsVK[index].sourceID)] {
                            newsVK[index].newsUserVK = userOfNews
                        }
                    }
                    self!.tableView.reloadData()
                })
            }
            self!.tableView.reloadData()
        }
        
        var nib = UINib(nibName: "NewsAvatarCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsAvatarCell")
        nib = UINib(nibName: "NewsPhotoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsPhotoCell")
        nib = UINib(nibName: "NewsCommentCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsCommentCell")
        nib = UINib(nibName: "NewsLikesCellSnapKit", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsLikesCellSnapKit")
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsVK.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellNews = UITableViewCell()
        let currentNews = newsVK[indexPath.section]
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsAvatarCell", for: indexPath) as! NewsAvatarCell
            cell.config(currentNews: currentNews)
            cellNews = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPhotoCell", for: indexPath) as! NewsPhotoCell
            cell.config(currentNews: currentNews)
            cellNews = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCommentCell", for: indexPath) as! NewsCommentCell
            cell.config(currentNews: currentNews)
            cellNews = cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesCellSnapKit", for: indexPath) as! NewsLikesCellSnapKit
            cell.config(currentNews: currentNews, index: indexPath.section)
            cellNews = cell
            
        default : break
        }
        return cellNews
    }

}
    
