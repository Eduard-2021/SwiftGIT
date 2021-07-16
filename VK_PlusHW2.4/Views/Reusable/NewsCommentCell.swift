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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(currentNews: OneNews){
        newsComment.text =  currentNews.text
    }
    
}
