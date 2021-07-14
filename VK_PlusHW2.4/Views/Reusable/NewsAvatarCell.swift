//
//  AvatarCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit
//import Kingfisher

class NewsAvatarCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var newsAvatarImage: UIImageView!
    @IBOutlet weak var newsAvatarName: UILabel!
    @IBOutlet weak var newsAvatarDate: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func config(currentNews: OneNews) {
        if currentNews.sourceID < 0 {
            newsAvatarImage.kf.setImage(with: URL(string: currentNews.newsGroupVK.imageGroupURL))
            newsAvatarName.text = currentNews.newsGroupVK.nameGroup
        }
        else {
            newsAvatarImage.kf.setImage(with: URL(string: currentNews.newsUserVK.userAvatarURL))
            newsAvatarName.text = currentNews.newsUserVK.firstName + " " + currentNews.newsUserVK.lastName
        }
        newsAvatarDate.text = converDate(dateNoConvert: currentNews.date)
    }
    
    
    func converDate(dateNoConvert: Double) -> String {
        let date = NSDate(timeIntervalSince1970: dateNoConvert)

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YYYY hh:mm a"

        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        return dateString
    }
}
