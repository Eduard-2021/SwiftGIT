//
//  NewsTableViewController.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit


class NewsTableViewController: UITableViewController {
    
    private let networkService = MainNetworkService()
    

//    static var news : [News] =
//        [News(avatarPhoto : UIImage(named: "1")!, avatarName: "1", date: "12.04.2021", photo: UIImage(named: "1")!, Comment: "Первый информационный пост", numberOfLiles: 5, iLike: true, numberOfViews: 30),
//         News(avatarPhoto : UIImage(named: "1")!, avatarName: "1", date: "14.04.2021", photo: UIImage(named: "1")!, Comment: "Второй информационный пост", numberOfLiles: 12, iLike: false, numberOfViews: 43),
//         News(avatarPhoto : UIImage(named: "1")!, avatarName: "1", date: "17.04.2021", photo: UIImage(named: "1")!, Comment: "Третий информационный пост", numberOfLiles: 6, iLike: true, numberOfViews: 20),
//         News(avatarPhoto : UIImage(named: "1")!, avatarName: "1", date: "18.04.2021", photo: UIImage(named: "1")!, Comment: "Четверный информационный пост", numberOfLiles: 10, iLike: false, numberOfViews: 15),]
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//       500.0
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkService.getNews { [weak self] vkResponse in
            guard let newsVKUnwrapped = vkResponse?.response.items else {return}
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
        nib = UINib(nibName: "NewsLikesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsLikesCell")
        
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
//            cell.newsPhoto.image =  NewsTableViewController.news[indexPath.section].photo
//            cell.newsPhoto.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            cellNews = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCommentCell", for: indexPath) as! NewsCommentCell
            cell.config(currentNews: currentNews)
            cellNews = cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesCell", for: indexPath) as! NewsLikesCell
            cell.config(currentNews: currentNews, index: indexPath.section)
            cellNews = cell
            
        default : break
        }
        return cellNews
    }

}
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}
