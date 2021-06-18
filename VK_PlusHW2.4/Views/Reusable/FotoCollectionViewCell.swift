//
//  FotoCollectionViewCell.swift
//  VK_PlusHW8.2
//
//  Created by Eduard on 25.04.2021.
//

import UIKit

class FotoCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var FotoOfFriend: UIImageView!
    @IBOutlet weak var serNumberPhoto: UILabel!
    @IBOutlet weak var serNumberUser: UILabel!
    @IBOutlet weak var numberLikes: UILabel!
    @IBOutlet weak var buttonLikeColor: UIButton!
    @IBAction func buttonLikeState(_ sender: UIButton) {
        
        guard let indexUser = Int(serNumberUser.text!),  let indexPhoto = Int(serNumberPhoto.text!) else {return}
        
        var section = 0
        var row = 0
        
        for (indexSection,friendsInSection) in FriendsViewTableController.friendsSorted.enumerated() {
            for (indexRow,friend) in friendsInSection.enumerated() {
                if friend.serialNumberUser == indexUser {
                    section = indexSection
                    row = indexRow
                }
            }
        }
       
        if buttonLikeColor.currentImage == UIImage(named: "NoLike") {

            UIView.transition(with: buttonLikeColor,
                              duration: 0.5,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.buttonLikeColor.setImage(UIImage(named: "Like")!, for: .normal)
                              },
                              completion: nil)
            
            FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].numLikes += 1
            
            UIView.transition(with: numberLikes,
                              duration: 0.5,
                              options: .transitionCurlDown,
                              animations: {
                            
                                self.numberLikes.text = String(FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].numLikes)
                              },
                              completion: nil)
            
            FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].i_like = true

        }

        else {
            UIView.transition(with: buttonLikeColor,
                              duration: 0.5,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.buttonLikeColor.setImage(UIImage(named: "NoLike")!, for: .normal)
                              },
                              completion: nil)
            
            FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].numLikes -= 1
            UIView.transition(with: numberLikes,
                              duration: 0.5,
                              options: .transitionCurlDown,
                              animations: {
                            
                                self.numberLikes.text = String(FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].numLikes)
                              },
                              completion: nil)
            
            FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].i_like = false
          
        }
    }
    
}
