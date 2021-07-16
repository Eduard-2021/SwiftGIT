//
//  NewsLikesCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

class NewsLikesCell: UITableViewCell {
    
    private var indexNews = 0

    @IBOutlet weak var newsNumberOfLikes: UILabel!
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var newsButtonLikesImage: UIButton!
    @IBOutlet weak var newsNumberOfViews: UILabel!
    @IBAction func newsButtonLikesAction(_ sender: Any) {
        

        if newsButtonLikesImage.currentImage == UIImage(named: "NoLike") {
            UIView.transition(with: newsButtonLikesImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.newsButtonLikesImage.setImage(UIImage(named: "Like")!, for: .normal)
                              },
                              completion: nil)
            
            
            
            
            newsVK[indexNews].likes.count += 1
            newsVK[indexNews].likes.userLikes = 1
            newsNumberOfLikes.text = String(newsVK[indexNews].likes.count)
        }
        else {
            UIView.transition(with: newsButtonLikesImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.newsButtonLikesImage.setImage(UIImage(named: "NoLike")!, for: .normal)
                              },
                              completion: nil)
            
            
            newsVK[indexNews].likes.count -= 1
            newsVK[indexNews].likes.userLikes = 0
            newsNumberOfLikes.text = String(newsVK[indexNews].likes.count)
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(currentNews: OneNews, index: Int) {
        indexNews = index
        newsNumberOfLikes.text = String(currentNews.likes.count)
        newsNumberOfViews.text = String(currentNews.views.count)
        section.text = String(index)
        if currentNews.likes.userLikes == 1 {
            newsButtonLikesImage.setImage(UIImage(named: "Like")!, for: .normal)
        }
        else {
            newsButtonLikesImage.setImage(UIImage(named: "NoLike")!, for: .normal)
        }
    }
}
