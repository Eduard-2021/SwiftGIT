//
//  AvatarImage.swift
//  VK_PlusHW3
//
//  Created by Eduard on 11.04.2021.
//

import UIKit

class AvatarImage: UIImageView {

var borderColor: UIColor = .darkGray
var borderWidth: CGFloat = 1.5
var cornerRadius: CGFloat = 40
    
    override func awakeFromNib() {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
