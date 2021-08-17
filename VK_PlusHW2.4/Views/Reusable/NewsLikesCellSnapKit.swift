//
//  NewsLikeSellSnapKit.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 22.07.2021.
//

import UIKit
import SnapKit

class NewsLikesCellSnapKit: UITableViewCell {
        
//    @IBOutlet weak var contentView: UIView!
    
    private var indexNews = 0
    
    private var newsNumberOfLikes: UILabel = {
        let label = UILabel()
        label.tintColor = .systemGray2
        return label
    }()
    private var section: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    private var newsNumberOfViews: UILabel = {
        let label = UILabel()
        label.tintColor = .systemGray2
        return label
    }()
    private var newsNumberOfComments: UILabel = {
        let label = UILabel()
        label.tintColor = .systemGray2
        return label
    }()
    private var newsNumberOfReposts: UILabel = {
        let label = UILabel()
        label.tintColor = .systemGray2
        return label
    }()
    private var newsButtonLikesImage: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .systemGray2
        button.titleLabel?.backgroundColor = .systemBackground
        return button
    }()
    private var viewsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.backgroundColor = .systemBackground
        return button
    }()
    private var repostButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        button.tintColor = .systemGray2
        button.titleLabel?.backgroundColor = .systemBackground
        return button
    }()
    private var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .systemGray2
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
        contentView.addSubview(newsNumberOfLikes)
        contentView.addSubview(section)
        contentView.addSubview(newsNumberOfViews)
        contentView.addSubview(newsNumberOfComments)
        contentView.addSubview(newsNumberOfReposts)
        contentView.addSubview(newsButtonLikesImage)
        contentView.addSubview(repostButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(viewsButton)
    }
    
    private func makeConstrans(){
     
        newsButtonLikesImage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(30)
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(10)
        }
        
        newsNumberOfLikes.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(newsButtonLikesImage.snp.trailing).offset(5)
        }

        section.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(newsNumberOfLikes.snp.centerY)
            make.leading.equalTo(newsNumberOfLikes.snp.trailing).offset(10)
        }
        
        commentButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(section.snp.centerY)
            make.leading.equalTo(section.snp.trailing).offset(20)
        }
        
        newsNumberOfComments.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(commentButton.snp.centerY)
            make.leading.equalTo(commentButton.snp.trailing).offset(5)
        }
        
        repostButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(commentButton.snp.centerY)
            make.leading.equalTo(commentButton.snp.trailing).offset(50)
        }
        
        newsNumberOfReposts.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(repostButton.snp.centerY)
            make.leading.equalTo(repostButton.snp.trailing).offset(5)
        }
        
        newsNumberOfViews.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        viewsButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(newsNumberOfViews.snp.leading).offset(-5)
        }
        
    }
    
    private func setActionButton(){
        newsButtonLikesImage.addTarget(self, action: #selector(pushLike), for: .touchUpInside)
    }
    
    @objc func pushLike(_ sender : UIButton){
        if newsButtonLikesImage.backgroundImage(for: .normal) == UIImage(systemName: "heart") {
            UIView.transition(with: newsButtonLikesImage,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.newsButtonLikesImage.tintColor = .red
                                self.newsButtonLikesImage.setBackgroundImage(UIImage(systemName: "heart.fill")!, for: .normal)
                              },
                              completion: nil)
            
            
            
            
            newsVK[indexNews].likes.count += 1
            newsVK[indexNews].likes.userLikes = 1
            newsNumberOfLikes.text = String(newsVK[indexNews].likes.count)
        }
        else {
            UIView.transition(with: newsButtonLikesImage,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.newsButtonLikesImage.tintColor = .systemGray2
                                self.newsButtonLikesImage.setBackgroundImage(UIImage(systemName: "heart")!, for: .normal)
                              },
                              completion: nil)
            
            
            newsVK[indexNews].likes.count -= 1
            newsVK[indexNews].likes.userLikes = 0
            newsNumberOfLikes.text = String(newsVK[indexNews].likes.count)
        }
    }
    
    func config(currentNewsAndIndex: NewsLikesViewModel) {
        indexNews = currentNewsAndIndex.indexNews
        newsNumberOfLikes.text = currentNewsAndIndex.newsNumberOfLikes
        newsNumberOfViews.text = currentNewsAndIndex.newsNumberOfViews
        newsNumberOfComments.text = currentNewsAndIndex.newsNumberOfComments
        newsNumberOfReposts.text = currentNewsAndIndex.newsNumberOfReposts
        section.text = currentNewsAndIndex.section
        newsButtonLikesImage.tintColor = currentNewsAndIndex.tintColor
        newsButtonLikesImage.setBackgroundImage(UIImage(systemName: currentNewsAndIndex.systemName)!, for: .normal)
    }
    }
