//
//  NewsLikesViewModelFactory.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 17.08.2021.
//

import UIKit

//С помощью паттерна Symple Factory упрощено конфигурирование ячейки NewsLikesCellSnapKit, которая создается классом NewsTableViewController

final class NewsLikesViewModelFactory {
    
    func constructViewModels(from currentNews:OneNews, and index: Int) -> NewsLikesViewModel{
        let indexNews = index
        let newsNumberOfLikes = String(currentNews.likes.count)
        let newsNumberOfViews = String(currentNews.views.count)
        let newsNumberOfComments = String(currentNews.comments.count)
        let newsNumberOfReposts = String(currentNews.reposts.count)
        let section = String(index)
        var tintColor: UIColor
        var systemName: String
        if currentNews.likes.userLikes == 1 {
            tintColor = .red
            systemName = "heart.fill"
        }
        else {
            tintColor = .systemGray2
            systemName = "heart"
         }
        return NewsLikesViewModel(indexNews: indexNews, newsNumberOfLikes: newsNumberOfLikes, newsNumberOfViews: newsNumberOfViews, newsNumberOfComments: newsNumberOfComments, newsNumberOfReposts: newsNumberOfReposts, section: section, tintColor: tintColor, systemName: systemName)
    }
}
