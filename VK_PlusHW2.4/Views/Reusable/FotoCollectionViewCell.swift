//
//  FotoCollectionViewCell.swift
//  VK_PlusHW8.2
//
//  Created by Eduard on 25.04.2021.
//

import UIKit
import Kingfisher
import RealmSwift

class FotoCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var FotoOfFriend: UIImageView!
    @IBOutlet weak var serNumberPhoto: UILabel!
    @IBOutlet weak var serNumberUser: UILabel!
    @IBOutlet weak var numberLikes: UILabel!
    @IBOutlet weak var buttonLikeColor: UIButton!
    
    private let networkService = MainNetworkService()
    var realmUserPhotos = try? RealmService.load(typeOf: RealmUserPhoto.self, sortedKey: "serialNumberPhoto")
    
    
    @IBAction func buttonLikeState(_ sender: UIButton) {
        
        guard let indexUser = Int(serNumberUser.text!),  let indexPhoto = Int(serNumberPhoto.text!) else {return}
        
        var section = 0
        var row = 0
        
        var likedPhotoOfUser = realmUserPhotos!.filter("idUser == %@", indexUser, "serialNumberPhoto == %@", indexPhoto)
        likedPhotoOfUser = likedPhotoOfUser.filter("serialNumberPhoto == %@", indexPhoto)
        
//        for (indexSection,friendsInSection) in FriendsViewTableController.friendsSorted.enumerated() {
//            for (indexRow,friend) in friendsInSection.enumerated() {
//                if friend.id == indexUser {
//                    section = indexSection
//                    row = indexRow
//                }
//            }
//        }
       
        if buttonLikeColor.currentImage == UIImage(named: "NoLike") {

            UIView.transition(with: buttonLikeColor,
                              duration: 0.5,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.buttonLikeColor.setImage(UIImage(named: "Like")!, for: .normal)
                              },
                              completion: nil)
            
            if let likedPhotoOfUser = likedPhotoOfUser.first {
                do {
                    let realm = try Realm()
                    try realm.write {
                        likedPhotoOfUser.numLikes += 1
                    }
                } catch {
                    print(error)
                }
            }
            
            //FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].numLikes += 1
            
            UIView.transition(with: numberLikes,
                              duration: 0.5,
                              options: .transitionCurlDown,
                              animations: {
                            
                                self.numberLikes.text = String(likedPhotoOfUser.first!.numLikes)
                              },
                              completion: nil)
            
//            FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].i_like = true
            if let likedPhotoOfUser = likedPhotoOfUser.first {
                do {
                    let realm = try Realm()
                    try realm.write {
                        likedPhotoOfUser.i_like=true
                    }
                } catch {
                    print(error)
                }
            }
            

        }

        else {
            UIView.transition(with: buttonLikeColor,
                              duration: 0.5,
                              options: .transitionFlipFromBottom,
                              animations: {
                                self.buttonLikeColor.setImage(UIImage(named: "NoLike")!, for: .normal)
                              },
                              completion: nil)
            
//            FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].numLikes -= 1
            if let likedPhotoOfUser = likedPhotoOfUser.first {
                do {
                    let realm = try Realm()
                    try realm.write {
                        likedPhotoOfUser.numLikes -= 1
                    }
                } catch {
                    print(error)
                }
            }
            
            
            UIView.transition(with: numberLikes,
                              duration: 0.5,
                              options: .transitionCurlDown,
                              animations: {
                            
                                self.numberLikes.text = String(likedPhotoOfUser.first!.numLikes)
                              },
                              completion: nil)
            
//            FriendsViewTableController.friendsSorted[section][row].images[indexPhoto-1].i_like = false
            if let likedPhotoOfUser = likedPhotoOfUser.first {
                do {
                    let realm = try Realm()
                    try realm.write {
                        likedPhotoOfUser.i_like=false
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func configure(
        imageURL: String,
        numLikes: Int,
        i_like: Bool,
        id: Int,
        serialNumberPhoto:Int) {
        FotoOfFriend.kf.setImage(with: URL(string: imageURL))
        numberLikes.text = String(numLikes)
        if i_like {
            buttonLikeColor.setImage(UIImage(named: "Like")!, for: .normal)
        }
            else {
                buttonLikeColor.setImage(UIImage(named: "NoLike")!, for: .normal)
            }
       serNumberUser.text = String(id)
       serNumberPhoto.text = String(serialNumberPhoto)
        
    }
}

