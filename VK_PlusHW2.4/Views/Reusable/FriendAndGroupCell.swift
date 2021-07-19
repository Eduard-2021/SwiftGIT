//
//  FriendAndGroupCell.swift
//  VK_PlusHW5
//
//  Created by Eduard on 18.04.2021.
//

import UIKit
import Kingfisher

class FriendAndGroupCell: UITableViewCell {

    @IBOutlet weak var imageOfFriendOrGroup: UIImageView!
    @IBOutlet weak var nameOfFriendOrGroup: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeGradient(self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageOfFriendOrGroup.addGestureRecognizer(tapGesture)
        imageOfFriendOrGroup.isUserInteractionEnabled = true

    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                       self.imageOfFriendOrGroup.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
                       },
                       completion: {_ in
                        UIView.animate(withDuration: 0.5,
                                       delay: 0,
                                       usingSpringWithDamping: 0.3,
                                       initialSpringVelocity: 1,
                                       options: [],
                                       animations: {
                                        self.imageOfFriendOrGroup.transform = .identity
                                       },
                                       completion: nil)
                        
                        
                       })
    }
    func configure(
        imageURL: String,
        name: String) {
        
        PhotoService.single.getImage(urlString: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageOfFriendOrGroup.image = image
            }
        }
//        imageOfFriendOrGroup.kf.setImage(with: URL(string: imageURL))
        nameOfFriendOrGroup.text = name
    }
    
}
