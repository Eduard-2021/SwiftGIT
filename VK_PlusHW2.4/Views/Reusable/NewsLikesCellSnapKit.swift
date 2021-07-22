//
//  NewsLikeSellSnapKit.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 22.07.2021.
//

import UIKit
import SnapKit

class NewsLikesCellSnapKit: UITableViewCell {
        
    @IBOutlet weak var contentViewCellNews: UIView!
    
    private var indexNews = 0
    
    var newsNumberOfLikes: UILabel = {
        let label = UILabel()
        return label
    }()
    private var section: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    private var newsNumberOfViews: UILabel = {
        let label = UILabel()
        return label
    }()
    private var newsButtonLikesImage: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.backgroundColor = .systemBackground
        return button
    }()
    private var viewsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.titleLabel?.backgroundColor = .systemBackground
        return button
    }()
    private var repostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        button.titleLabel?.backgroundColor = .systemBackground
        return button
    }()
    private var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.titleLabel?.backgroundColor = .systemBackground
        return button
    }()
    
        override func awakeFromNib() {
            super.awakeFromNib()
            addSubviews()
            setActionButton()
            makeConstrans()
        }
    
    private func addSubviews(){
        contentViewCellNews.addSubview(newsNumberOfLikes)
        contentViewCellNews.addSubview(section)
        contentViewCellNews.addSubview(newsNumberOfViews)
        contentViewCellNews.addSubview(newsButtonLikesImage)
        contentViewCellNews.addSubview(repostButton)
        contentViewCellNews.addSubview(commentButton)
        contentViewCellNews.addSubview(viewsButton)
    }
    
    private func makeConstrans(){
     
        newsButtonLikesImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(32)
            make.centerY.equalTo(contentViewCellNews.snp.centerY)
            make.leading.equalTo(contentViewCellNews.snp.leading).offset(10)
        }
        
        newsNumberOfLikes.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(newsButtonLikesImage.snp.centerY)
            make.leading.equalTo(newsButtonLikesImage.snp.trailing).offset(5)
        }

        section.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(newsNumberOfLikes.snp.centerY)
            make.leading.equalTo(newsNumberOfLikes.snp.trailing).offset(10)
        }
        
        commentButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(section.snp.centerY)
            make.leading.equalTo(section.snp.trailing).offset(60)
        }
        
        repostButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(commentButton.snp.centerY)
            make.leading.equalTo(commentButton.snp.trailing).offset(90)
        }
        
        newsNumberOfViews.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentViewCellNews.snp.centerY)
            make.trailing.equalTo(contentViewCellNews.snp.trailing).offset(-16)
        }
        
        viewsButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentViewCellNews.snp.centerY)
            make.trailing.equalTo(newsNumberOfViews.snp.leading).offset(-16)
        }
        
    }
    
    private func setActionButton(){
        newsButtonLikesImage.addTarget(self, action: #selector(pushLike), for: .touchUpInside)
    }
    
    @objc func pushLike(_ sender : UIButton){
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
