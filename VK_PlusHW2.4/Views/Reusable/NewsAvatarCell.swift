//
//  AvatarCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit

class NewsAvatarCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var NewsAvatarImage: UIImageView!
    @IBOutlet weak var NewsAvatarName: UILabel!
    @IBOutlet weak var NewsAvatarDate: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
