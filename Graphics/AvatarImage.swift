//
//  AvatarImage.swift
//  VK_PlusHW3
//
//  Created by Eduard on 11.04.2021.
//

import UIKit

@IBDesignable class AvatarImage: UIImageView {

    @IBInspectable var borderColor: UIColor = .darkGray
    @IBInspectable var borderWidth: CGFloat = 1.5
    @IBInspectable var cornerRadius: CGFloat = 40
    
    override func awakeFromNib() {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
