//
//  NewsCommentCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

class NewsCommentCell: UITableViewCell {

    @IBOutlet weak var newsComment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(currentNews: OneNews){
        newsComment.text =  currentNews.text
        separatorInset.left = contentView.frame.size.width
    }
}
