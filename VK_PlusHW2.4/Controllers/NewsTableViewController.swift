//
//  NewsTableViewController.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

protocol DelegeteForChangeSizeNewsCommenCell {
    func changeSizeOfCommentCell(data: NecessaryDatesForChangeSizeNewsCommentCell)
}

class NewsTableViewController: UITableViewController, DelegeteForChangeSizeNewsCommenCell {
    
    let showMoreOrLessCell = ShowMoreOrLessCell()
    
    private let networkService = MainNetworkService()
    private let currentTime = Date().timeIntervalSince1970
    private let durationOneDay : Double = 60*60*24
    private var nextGroupNews = ""
    private var isLoading = false
    private var dataForUpdateNewsCommentCell=NecessaryDatesForChangeSizeNewsCommentCell()
    static var sectionsWithFullComments = [Int:Bool]()
    private let maxHeightForCellCommets: CGFloat = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNewsFromNet()
        registrationCells()
        setupRefreshControl()
        tableView.prefetchDataSource = self
        
        showMoreOrLessCell.mainNewsVC = self
        // Использование Notification Center для обмена информацией о нажатии кнопок More.../Less...
//        NotificationCenter.default.addObserver(self, selector: #selector(changeHeightOfCommentCell), name: NSNotification.Name(rawValue: "changeHeightOfCommentCell"), object: nil)

    }
    
    private func getNewsFromNet(){
        networkService.getNews(startTime: currentTime-durationOneDay, endTime: currentTime-7200) { [weak self] (vkResponseItems,vkResponsePRofiles,vkResponseGroups, vkResponseNextGroup) in
            guard let itemsVKUnwrapped = vkResponseItems?.response.items,
                  let nextGroup = vkResponseNextGroup,
                  let self=self
            else {return}
            self.nextGroupNews = nextGroup.response.nextGroupFrom
            newsVK = itemsVKUnwrapped
//            if let groupsVKUnwrapped = vkResponseGroups?.response.groups {
//                self.loadGroupsInNewVK(groupsNews: groupsVKUnwrapped)
//            }
//            if let proFilesVKUnwrapped = vkResponsePRofiles?.response.profiles {
//                self.loadUsersInNews(usersNews: proFilesVKUnwrapped)
//            }
            self.loadGroupsAndUsersForNews(refresh: true)
            self.calculateTextHeight(from: 0, to: newsVK.count-1)
            newsVK = self.calculatingNumberPhotoInAttachment(news: newsVK)
            newsVK = self.calculationAspectRatioVKPhoto(news: newsVK)
            self.tableView.reloadData()
        }
    }
    
    // Правильное направление и код, но необходимо доработать с учетом комментов от левых пользователей
//    private func loadGroupsInNewVK(groupsNews: [VKGroup]){
//        var newsVKTemp = newsVK
//        for (index,value) in newsVK.enumerated() {
//            if value.sourceID < 0 {
//                let source = groupsNews.first(where: { $0.idGroup == abs(value.sourceID) })
//                if let source = source {
//                    newsVKTemp[index].newsGroupVK = source
//                }
//            }
//        }
//        newsVK = newsVKTemp
//    }
//
//    private func loadUsersInNews(usersNews: [VKUser]){
//        var newsVKTemp = newsVK
//        for (index,value) in newsVK.enumerated() {
//            if value.sourceID > 0 {
//                let source = usersNews.first(where: { $0.idUser == value.sourceID })
//                if let source = source {
//                    newsVKTemp[index].newsUserVK = source
//                }
//            }
//        }
//        newsVK = newsVKTemp
//    }

    private func loadGroupsAndUsersForNews(refresh:Bool){
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
            networkService.getGroupsOfNews(groupsIDs: groupsIDs, completion: { [weak self] vkResponse in
                guard let groupsOfNews = vkResponse?.response else {return}
                var groupsOfNewsDict = [Int:VKGroup]()
                for value in groupsOfNews {groupsOfNewsDict[value.idGroup] = value}
                for (index, _) in newsVK.enumerated() {
                    if let groupsOfNews = groupsOfNewsDict[abs(newsVK[index].sourceID)] {
                      newsVK[index].newsGroupVK = groupsOfNews
                        }
                }
                if refresh {self!.tableView.reloadData()}
            })
        }
        if !usersIDs.isEmpty {
            usersIDs.removeLast()
            networkService.getUsersOfNews(usersIDs: usersIDs, completion: { [weak self] vkResponse in
                guard let usersOfNews = vkResponse?.response else {return}
                var usersOfNewsDict = [Int:VKUser]()
                for value in usersOfNews {usersOfNewsDict[value.idUser] = value}
                for (index, _) in newsVK.enumerated() {
                    if let userOfNews = usersOfNewsDict[abs(newsVK[index].sourceID)] {
                        newsVK[index].newsUserVK = userOfNews
                    }
                }
                if refresh {self!.tableView.reloadData()}
            })
        }
    }
    
    private func registrationCells() {
        var nib = UINib(nibName: "NewsAvatarCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsAvatarCell")
        nib = UINib(nibName: "NewsPhotoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsPhotoCell")
        nib = UINib(nibName: "NewsCommentCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsCommentCell")
        nib = UINib(nibName: "NewsLikesCellSnapKit", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsLikesCellSnapKit")
        nib = UINib(nibName: "ShowMoreOrLessCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ShowMoreOrLessCell")
    }
    
    fileprivate func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        tableView.refreshControl?.tintColor = .red
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
       }

    @objc func refreshNews(){
            tableView.refreshControl?.beginRefreshing()
            let mostFreshNewsDate = newsVK.first?.date ?? currentTime
            networkService.getNews(startTime: mostFreshNewsDate + 1) { [weak self] (vkResponseItems,vkResponsePRofiles,vkResponseGroups, vkResponseNextGroup ) in
                guard var newsVKUnwrapped = vkResponseItems?.response.items,
                      let self=self
                else {return}
                self.tableView.refreshControl?.endRefreshing()
                guard newsVKUnwrapped.count > 0 else { return }
                newsVKUnwrapped = self.calculatingNumberPhotoInAttachment(news: newsVKUnwrapped)
                newsVKUnwrapped = self.calculationAspectRatioVKPhoto(news: newsVKUnwrapped)
                newsVK = newsVKUnwrapped + newsVK
                let indexSet = IndexSet(integersIn: 0..<newsVKUnwrapped.count)
                
                var refrashsectionsWithFullComments = [Int:Bool]()
                for value in NewsTableViewController.sectionsWithFullComments {
                    refrashsectionsWithFullComments[value.key+newsVKUnwrapped.count] = value.value
                }
                NewsTableViewController.sectionsWithFullComments = refrashsectionsWithFullComments
                
//                self.loadGroupsInNewVK(groupsNews: groupsVKUnwrapped)
//                self.loadUsersInNews(usersNews: proFilesVKUnwrapped)
                self.loadGroupsAndUsersForNews(refresh: true)
                self.calculateTextHeight(from: 0, to: newsVKUnwrapped.count-1)
                self.tableView.insertSections(indexSet, with: .automatic)
            }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsVK.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    private func calculateTextHeight(from: Int, to: Int){
        for index in from...to {
            newsVK[index].textHeight = findHeightForText(text: newsVK[index].text, havingWidth: self.view.frame.size.width, andFont: UIFont.systemFont(ofSize: 17.0)).height
        }
    }
    
    private func calculatingNumberPhotoInAttachment(news: [OneNews]) -> [OneNews] {
        var returnNewsVK = news
        for (index, oneNews) in news.enumerated() {
            var numberPhoto = 0
            for value in oneNews.attachments {
                if value.type == "photo" {
                    numberPhoto += 1
                }
            }
            returnNewsVK[index].numberPhotoInAttachement = numberPhoto
        }
        return returnNewsVK
    }
    
    private func calculationAspectRatioVKPhoto(news: [OneNews]) -> [OneNews]{
        var returnNewsVK = news
        for (indexOneNews, valueOneNews) in news.enumerated() {
                for (indexCurrentAttachment, valueCurrentAttachment) in valueOneNews.attachments.enumerated() {
                    if valueCurrentAttachment.type == "photo" {
                        let heightCurrentPhoto = Double(valueCurrentAttachment.attachmentVKPhoto.photo.sizes[0].height)
                        let widthCurrentPhoto = Double(valueCurrentAttachment.attachmentVKPhoto.photo.sizes[0].width)
                        returnNewsVK[indexOneNews].attachments[indexCurrentAttachment].attachmentVKPhoto.photo.aspectRatio = heightCurrentPhoto/widthCurrentPhoto
                    }
                }
        }
        return returnNewsVK
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var pickheight = newsVK[indexPath.section].textHeight
    
        switch indexPath.row {
            case 1:
                switch newsVK[indexPath.section].numberPhotoInAttachement {
                case 0:
                    return 0
                case 1:
                    var proportion = 1.0
                    for value in newsVK[indexPath.section].attachments {
                        if value.type == "photo" {
                            proportion = value.attachmentVKPhoto.photo.aspectRatio
                        }
                    }
                    return CGFloat(Double(view.frame.size.width) * proportion)
                case 2:
                    return view.frame.size.width/2
                case 3:
                    return view.frame.size.width/3
                case 5:
                    return view.frame.size.width/3 + view.frame.size.width/2 + 7
                default:
                    return view.frame.size.width*1.4
                }
                
            case 2:
                if pickheight > maxHeightForCellCommets {
                    pickheight = maxHeightForCellCommets
                    guard let cellWithButtonMoreLess = NewsTableViewController.sectionsWithFullComments[indexPath.section],
                          cellWithButtonMoreLess else {
                        NewsTableViewController.sectionsWithFullComments[indexPath.section] = false
                        return pickheight}
                }
                return UITableView.automaticDimension
            case 3:
                if NewsTableViewController.sectionsWithFullComments[indexPath.section] == nil {
                    return 0
                }
                return UITableView.automaticDimension
            default:
                return UITableView.automaticDimension
        }
    
    }
 
    func findHeightForText(text: String, havingWidth widthValue: CGFloat, andFont font: UIFont) -> CGSize {
        var size = CGSize.zero
            if text.isEmpty == false {
                let frame = text.boundingRect(with:CGSize(width: widthValue, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
                size = CGSize(width: frame.size.width, height: ceil(frame.size.height))
            }
            return size
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoreOrLessCell", for: indexPath) as! ShowMoreOrLessCell
            cell.mainNewsVC = self
            cell.config(numberSection: indexPath.section)
            cellNews = cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLikesCellSnapKit", for: indexPath) as! NewsLikesCellSnapKit
            cell.config(currentNews: currentNews, index: indexPath.section)
            cellNews = cell
            
        default : break
        }
        return cellNews
    }
    
    //Метод отработки данных, полученных через Notification Center (в данной реализации не используется)
    @objc func changeHeightOfCommentCell(_ notification: Notification){
        guard let data = notification.userInfo as? [String: NecessaryDatesForChangeSizeNewsCommentCell] else {return}
        dataForUpdateNewsCommentCell = data["dates"]!
        
        if  dataForUpdateNewsCommentCell.moreButtonPressed {
            NewsTableViewController.sectionsWithFullComments[dataForUpdateNewsCommentCell.numberSectionForUpdate] = true}
        else {
            NewsTableViewController.sectionsWithFullComments[dataForUpdateNewsCommentCell.numberSectionForUpdate] = false
        }
        tableView.reloadRows(at: [IndexPath(row: 2, section: dataForUpdateNewsCommentCell.numberSectionForUpdate),IndexPath(row: 3, section: dataForUpdateNewsCommentCell.numberSectionForUpdate)], with: .automatic)
    }

    func changeSizeOfCommentCell(data: NecessaryDatesForChangeSizeNewsCommentCell){
        dataForUpdateNewsCommentCell = data
        
        if  dataForUpdateNewsCommentCell.moreButtonPressed {
            NewsTableViewController.sectionsWithFullComments[dataForUpdateNewsCommentCell.numberSectionForUpdate] = true}
        else {
            NewsTableViewController.sectionsWithFullComments[dataForUpdateNewsCommentCell.numberSectionForUpdate] = false
        }
        tableView.reloadRows(at: [IndexPath(row: 2, section: dataForUpdateNewsCommentCell.numberSectionForUpdate),IndexPath(row: 3, section: dataForUpdateNewsCommentCell.numberSectionForUpdate)], with: .automatic)
    }
    
}



extension NewsTableViewController: UITableViewDataSourcePrefetching {
   func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
       guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
       if maxSection > newsVK.count - 6,
           !isLoading {
           isLoading = true
        networkService.getNews(startTime: currentTime-durationOneDay, nextGroup: nextGroupNews)
        { [weak self] (vkResponseItems,vkResponsePRofiles,vkResponseGroups, vkResponseNextGroup ) in
               guard let self = self,
                     let newsVKUnwrapped = vkResponseItems?.response.items,
                     let nextGroup = vkResponseNextGroup
               else {return}
               self.nextGroupNews = nextGroup.response.nextGroupFrom
               let indexSet = IndexSet(integersIn: newsVK.count ..< newsVK.count + newsVKUnwrapped.count)
               newsVK.append(contentsOf: newsVKUnwrapped)
               self.calculateTextHeight(from: newsVK.count-newsVKUnwrapped.count, to: newsVK.count-1)
               newsVK = self.calculatingNumberPhotoInAttachment(news: newsVK)
               newsVK = self.calculationAspectRatioVKPhoto(news: newsVK)
               self.loadGroupsAndUsersForNews(refresh: false)
               self.tableView.insertSections(indexSet, with: .automatic)
               self.isLoading = false
           }
       }
   }
}
    
