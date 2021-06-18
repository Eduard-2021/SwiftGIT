//
//  NewsLikesCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

class NewsLikesCell: UITableViewCell {

    @IBOutlet weak var newsNumberOfLikes: UILabel!
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var newsButtonLikesImage: UIButton!
    @IBOutlet weak var newsNumberOfViews: UILabel!
    @IBAction func newsButtonLikesAction(_ sender: Any) {
        
        guard let section = Int(section.text!) else {return}

        
        
        if newsButtonLikesImage.currentImage == UIImage(named: "NoLike") {
            UIView.transition(with: newsButtonLikesImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.newsButtonLikesImage.setImage(UIImage(named: "Like")!, for: .normal)
                              },
                              completion: nil)
            
            
            
            
            NewsTableViewController.news[section].numberOfLiles += 1
            NewsTableViewController.news[section].iLike = true
            newsNumberOfLikes.text = String(NewsTableViewController.news[section].numberOfLiles)
        }
        else {
            UIView.transition(with: newsButtonLikesImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.newsButtonLikesImage.setImage(UIImage(named: "NoLike")!, for: .normal)
                              },
                              completion: nil)
            
            
            NewsTableViewController.news[section].numberOfLiles -= 1
            NewsTableViewController.news[section].iLike = false
            newsNumberOfLikes.text = String(NewsTableViewController.news[section].numberOfLiles)
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
